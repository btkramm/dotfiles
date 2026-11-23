import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { Diagram } from '../types'

const MAX_DIAGRAMS = 50
const FENCE = /(```|~~~)mermaid[^\n]*\n([\s\S]*?)\n[ \t]*\1/g

const diagrams = atom({ plugin: 'rex-mermaid', key: 'diagrams' } as const, [], { shape: 'diagrams-1' })
const latest = atom({ plugin: 'rex-mermaid', key: 'latest' } as const, [], { shape: 'latest-1' })
const isHidden = atom({ plugin: 'rex-mermaid', key: 'isHidden' } as const, false)

export function fenced(text: string): string[] {
  return [...text.matchAll(FENCE)].map(match => (match[2] ?? '').trim()).filter(source => source !== '')
}

export function kindOf(source: string): string {
  const lines = source.split('\n').map(line => line.trim())
  let isFrontmatter = lines[0] === '---'

  for (const line of lines.slice(isFrontmatter ? 1 : 0)) {
    if (isFrontmatter) {
      if (line === '---') isFrontmatter = false

      continue
    }

    if (line !== '' && !line.startsWith('%%')) return line.split(/\s/)[0] ?? 'diagram'
  }

  return 'diagram'
}

async function remember($: EngineInterface, sources: readonly string[]): Promise<void> {
  if (sources.length === 0) return

  const list = [...(await read($, diagrams))]
  const numbers: number[] = []

  for (const source of sources) {
    const known = list.find(diagram => diagram.source === source)

    if (known !== undefined) {
      numbers.push(known.number)

      continue
    }

    const number = (list[list.length - 1]?.number ?? 0) + 1

    list.push({ number, kind: kindOf(source), source })
    numbers.push(number)
  }

  await update($, diagrams, () => list.slice(-MAX_DIAGRAMS))
  await update($, latest, current => [...new Set([...current, ...numbers])])
  await update($, isHidden, () => false)
}

async function open($: EngineInterface, diagram: Diagram): Promise<string | undefined> {
  const session = await $.env.get('REX_SESSION')
  const block = await $.env.get('REX_BLOCK')

  if (session === undefined || block === undefined) return 'Claude Code is not running inside Rex.'

  const { CLAUDE_PLUGIN_DATA } = await $.process.hookEnv()
  const file = `${CLAUDE_PLUGIN_DATA}/diagram-${diagram.number}.mmd`

  await $.fs.write(file, `${diagram.source}\n`)

  const ran = await $.process.run(['rex', 'do', '-s', session, '-b', block, 'mermaid_preview', `file=${file}`])

  if (ran.exitCode !== 0) return `rex could not open diagram #${diagram.number}: ${ran.stderr.trim()}`

  return undefined
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: 'mermaid',
      description: 'Open a Mermaid diagram of this session in a Rex floating pane ([n] or list)',
    })

    return next(e)
  })

  on('turn.step', async function* ($, e, next) {
    const step = yield* next(e)

    if (e.agentId === undefined) {
      if (e.index === 0) await update($, latest, () => [])

      await remember($, fenced(step.answer))
    }

    return step
  })

  on('tool.call', { tool: 'Write' }, async ($, e, next) => {
    const ran = await next(e)

    if (ran.deny === undefined && ran.isError !== true) {
      await remember($, e.file_path.endsWith('.mmd') ? [e.content.trim()] : fenced(e.content))
    }

    return ran
  })

  on('tool.call', { tool: 'Edit' }, async ($, e, next) => {
    const ran = await next(e)

    if (ran.deny === undefined && ran.isError !== true) await remember($, fenced(e.new_string))

    return ran
  })

  on('command.run', { command: 'mermaid' }, async ($, e) => {
    const list = await read($, diagrams)
    const arg = e.args.trim()

    if (list.length === 0) return { text: 'No Mermaid diagrams in this session yet.', isTextDisplayOnly: true }

    if (arg === 'list') {
      return { text: list.map(diagram => `#${diagram.number} ${diagram.kind}`).join('\n'), isTextDisplayOnly: true }
    }

    const diagram = arg === '' ? list[list.length - 1] : list.find(one => String(one.number) === arg.replace(/^#/, ''))

    if (diagram === undefined) {
      return { text: `No diagram #${arg}. Run /mermaid list to see them.`, isTextDisplayOnly: true }
    }

    const error = await open($, diagram)

    return { text: error ?? `Opened diagram #${diagram.number} (${diagram.kind}) in Rex.`, isTextDisplayOnly: true }
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    const numbers = await read($, latest)

    if (e.props.hasSurvey || numbers.length === 0 || (await read($, isHidden))) return next(e)

    const shown = (await read($, diagrams)).filter(diagram => numbers.includes(diagram.number))

    if (shown.length === 0) return next(e)

    const { Box, Button, Text } = $.ui.resolve(e)

    const press = async (diagram: Diagram) => {
      const error = await open($, diagram)

      if (error !== undefined) $.ui.toast(error)
    }

    return (
      <Box>
        <Text dimColor>Mermaid </Text>
        {shown.map(diagram => (
          <Button key={`open-${diagram.number}`} label={`#${diagram.number} ${diagram.kind}`} onPress={() => press(diagram)} />
        ))}
        <Text> </Text>
        <Button key="hide" label="Hide" onPress={() => update($, isHidden, () => true)} />
      </Box>
    )
  })
}

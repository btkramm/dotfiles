import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { Diagram } from '../types'

const MAX_DIAGRAMS = 50
const FENCE = /(```|~~~)mermaid[^\n]*\n([\s\S]*?)\n[ \t]*\1/g

const diagrams = atom({ plugin: 'rex-mermaid', key: 'diagrams' } as const, [], { shape: 'diagrams-1' })
const bandNumbers = atom({ plugin: 'rex-mermaid', key: 'bandNumbers' } as const, [], { shape: 'bandNumbers-1' })
const isBandHidden = atom({ plugin: 'rex-mermaid', key: 'isBandHidden' } as const, false)

export function mermaidBlocks(text: string): string[] {
  return [...text.matchAll(FENCE)].map(match => (match[2] ?? '').trim()).filter(source => source !== '')
}

export function diagramKind(source: string): string {
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

function succeeded(result: { deny?: unknown; isError?: boolean }): boolean {
  return result.deny === undefined && result.isError !== true
}

async function addDiagrams($: EngineInterface, sources: readonly string[]): Promise<void> {
  if (sources.length === 0) return

  let addedNumbers: number[] = []

  // `update` can run this function again when the list changes. Thus it must
  // compute everything from `current`.
  await update($, diagrams, current => {
    const list = [...current]

    addedNumbers = sources.map(source => {
      const known = list.find(diagram => diagram.source === source)

      if (known !== undefined) return known.number

      const number = (list.at(-1)?.number ?? 0) + 1

      list.push({ number, kind: diagramKind(source), source })

      return number
    })

    return list.slice(-MAX_DIAGRAMS)
  })

  await update($, bandNumbers, current => [...new Set([...current, ...addedNumbers])])
  await update($, isBandHidden, () => false)
}

async function openInRex($: EngineInterface, diagram: Diagram): Promise<string | undefined> {
  const session = await $.env.get('REX_SESSION')
  const block = await $.env.get('REX_BLOCK')

  if (session === undefined || block === undefined) return 'Claude Code is not running inside Rex.'

  // All sessions share `CLAUDE_PLUGIN_DATA`, and each session numbers its
  // diagrams from 1. The session ID keeps the file names apart.
  const { CLAUDE_PLUGIN_DATA, CLAUDE_CODE_SESSION_ID } = await $.process.hookEnv()
  const file = `${CLAUDE_PLUGIN_DATA}/diagram-${CLAUDE_CODE_SESSION_ID}-${diagram.number}.mmd`

  await $.fs.write(file, `${diagram.source}\n`)

  const result = await $.process.run(['rex', 'do', '-s', session, '-b', block, 'mermaid_preview', `file=${file}`])

  if (result.exitCode !== 0) return `rex could not open diagram #${diagram.number}: ${result.stderr.trim()}`

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
      if (e.index === 0) await update($, bandNumbers, () => [])

      await addDiagrams($, mermaidBlocks(step.answer))
    }

    return step
  })

  on('tool.call', { tool: 'Write' }, async ($, e, next) => {
    const result = await next(e)

    if (succeeded(result)) {
      await addDiagrams($, e.file_path.endsWith('.mmd') ? [e.content.trim()] : mermaidBlocks(e.content))
    }

    return result
  })

  on('tool.call', { tool: 'Edit' }, async ($, e, next) => {
    const result = await next(e)

    if (succeeded(result)) await addDiagrams($, mermaidBlocks(e.new_string))

    return result
  })

  on('command.run', { command: 'mermaid' }, async ($, e) => {
    const list = await read($, diagrams)
    const arg = e.args.trim()

    if (list.length === 0) return { text: 'No Mermaid diagrams in this session yet.', isTextDisplayOnly: true }

    if (arg === 'list') {
      return { text: list.map(diagram => `#${diagram.number} ${diagram.kind}`).join('\n'), isTextDisplayOnly: true }
    }

    const wantedNumber = arg.replace(/^#/, '')
    const diagram = arg === '' ? list.at(-1) : list.find(known => String(known.number) === wantedNumber)

    if (diagram === undefined) {
      return { text: `No diagram #${arg}. Run /mermaid list to see them.`, isTextDisplayOnly: true }
    }

    const error = await openInRex($, diagram)

    return { text: error ?? `Opened diagram #${diagram.number} (${diagram.kind}) in Rex.`, isTextDisplayOnly: true }
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    const numbers = await read($, bandNumbers)

    if (e.props.hasSurvey || numbers.length === 0 || (await read($, isBandHidden))) return next(e)

    const shown = (await read($, diagrams)).filter(diagram => numbers.includes(diagram.number))

    if (shown.length === 0) return next(e)

    const { Box, Button, Text } = $.ui.resolve(e)

    const press = async (diagram: Diagram) => {
      const error = await openInRex($, diagram)

      if (error !== undefined) $.ui.toast(error)
    }

    return (
      <Box>
        <Text dimColor>Mermaid </Text>
        {shown.map(diagram => (
          <Button key={`open-${diagram.number}`} label={`#${diagram.number} ${diagram.kind}`} onPress={() => press(diagram)} />
        ))}
        <Text> </Text>
        <Button key="hide" label="Hide" onPress={() => update($, isBandHidden, () => true)} />
      </Box>
    )
  })
}

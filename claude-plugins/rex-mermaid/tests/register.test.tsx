import { expect, mock, test } from 'claude-code/testing'

import { diagramKind, mermaidBlocks } from '../hooks/register'

const BAND = {
  plugin: 'rex-mermaid',
  component: 'AbovePrompt',
  props: { hasSurvey: false, isCollapsed: false, isWorking: false, maxRows: 4 },
} as const

const MARKDOWN = [
  '# Design',
  '',
  '```mermaid',
  'flowchart LR',
  '  A --> B',
  '```',
  '',
  '~~~mermaid',
  '---',
  'title: Order',
  '---',
  '%% a comment',
  'sequenceDiagram',
  '  A->>B: hi',
  '~~~',
].join('\n')

test('mermaidBlocks finds backtick and tilde blocks, and diagramKind skips frontmatter and comments', () => {
  const sources = mermaidBlocks(MARKDOWN)

  expect(sources).toHaveLength(2)
  expect(sources.map(diagramKind)).toEqual(['flowchart', 'sequenceDiagram'])
  expect(mermaidBlocks('```python\nprint(1)\n```')).toHaveLength(0)
})

test('a written file with diagrams shows a band whose buttons open them in Rex', async ($, on) => {
  const runs: (readonly string[])[] = []

  mock.env(on, { REX_SESSION: 'session:1', REX_BLOCK: 'block:1' })
  on('tool.call', () => ({ result: {} }))
  on('process.hookEnv', () => ({ value: { CLAUDE_PLUGIN_DATA: '/data', CLAUDE_CODE_SESSION_ID: 'abc' } }))
  on('fs.write', () => ({ value: undefined }))
  on('process.run', (_, e) => {
    runs.push(e.argv)

    return { value: { exitCode: 0, stdout: '', stderr: '' } }
  })

  await $.tool.call({ tool: 'Write', file_path: '/repo/docs/design.md', content: MARKDOWN })

  const ui = await $.ui.mount({ ...BAND, surface: 'terminal' })

  expect(await ui.findAll({ type: 'Button' })).toHaveLength(3)

  await ui.press({ key: 'open-2' })

  expect(runs).toEqual([
    ['rex', 'do', '-s', 'session:1', '-b', 'block:1', 'mermaid_preview', 'file=/data/diagram-abc-2.mmd'],
  ])

  await ui.press({ key: 'hide' })

  expect(await ui.findAll({ type: 'Button' })).toHaveLength(0)

  await ui.unmount()
})

test('/mermaid explains when there is nothing to open or no Rex around', async ($, on) => {
  mock.env(on, {})
  on('tool.call', () => ({ result: {} }))
  on('process.hookEnv', () => ({ value: { CLAUDE_PLUGIN_DATA: '/data', CLAUDE_CODE_SESSION_ID: 'abc' } }))

  expect((await $.command.run({ command: 'mermaid', args: '' })).text).toBe('No Mermaid diagrams in this session yet.')

  await $.tool.call({ tool: 'Write', file_path: '/repo/flow.mmd', content: 'flowchart TD\n  A --> B\n' })

  expect((await $.command.run({ command: 'mermaid', args: 'list' })).text).toBe('#1 flowchart')
  expect((await $.command.run({ command: 'mermaid', args: '7' })).text).toBe('No diagram #7. Run /mermaid list to see them.')
  expect((await $.command.run({ command: 'mermaid', args: '' })).text).toBe('Claude Code is not running inside Rex.')
})

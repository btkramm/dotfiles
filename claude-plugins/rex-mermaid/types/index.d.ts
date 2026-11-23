export type Diagram = { number: number; kind: string; source: string }

declare module 'claude-code' {
  interface PluginState {
    'rex-mermaid': {
      diagrams: Shaped<Diagram[]>
      latest: Shaped<number[]>
      isHidden: boolean
    }
  }
}

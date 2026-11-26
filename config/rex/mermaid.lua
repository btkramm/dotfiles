local SHELL = 'com.superlogical.terminal.shell'
local VIEWER = os.getenv('HOME') .. '/personal/dotfiles/scripts/mermaid/mermaid-view.sh'

local function window_id_of_block(session_id, block_id)
  if block_id == nil then
    return nil
  end

  local view, err = rex.session.view({ session_id = session_id })

  if err ~= nil then
    error(err, 0)
  end

  for _, window in ipairs(view.windows or {}) do
    for _, layer in ipairs(window.layers or {}) do
      for _, block in ipairs(layer.blocks or {}) do
        if block.block_id == block_id then
          return window.window_id
        end
      end
    end
  end

  return nil
end

rex.action({
  name = 'mermaid_preview',
  title = 'Preview Mermaid Diagram',
  description = 'Render a Mermaid file and show it in a floating pane.',
  keywords = 'mermaid diagram preview render image',
  args = { file = 'string' },
  run = function(ctx, args)
    local _, err = rex.session.new_layer({
      window_id = window_id_of_block(ctx.session_id, ctx.block_id),
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      focus = true,
      layout = rex.layout.block({
        flavor = SHELL,
        -- The path is an argument. It is never part of the `-c` text.
        options = { command = { 'zsh', '-il', '-c', '"$0" "$@"', VIEWER, args.file } },
      }),
    })

    if err ~= nil then
      error(err, 0)
    end
  end,
})

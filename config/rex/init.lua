local TERMINAL = 'com.superlogical.terminal'
local SHELL = 'com.superlogical.terminal.shell'
local HOME = os.getenv('HOME')

local function current_cwd(block_id)
  local p = rex.block.call(TERMINAL, 'process', { block_id = block_id })

  if p and p.foreground and p.foreground.cwd then
    return p.foreground.cwd
  end

  return nil
end

-- Panes ----------------------------------------------------------------------

rex.bind('ctrl+shift+enter', 'pane.split.auto')
rex.bind('ctrl+shift+n', 'client.window.new')

rex.bind('ctrl+shift+v', 'pane.split', { direction = 'right' })
rex.bind('ctrl+shift+x', 'pane.split', { direction = 'down' })

rex.bind('ctrl+shift+h', 'pane.focus', { direction = 'left' })
rex.bind('ctrl+shift+j', 'pane.focus', { direction = 'down' })
rex.bind('ctrl+shift+k', 'pane.focus', { direction = 'up' })
rex.bind('ctrl+shift+l', 'pane.focus', { direction = 'right' })

rex.action({
  name = 'close_pane_or_tab',
  title = 'Close Pane or Tab',
  run = function(ctx, args)
    local _, err = rex.call('block.close', { session_id = ctx.session_id, block_id = ctx.block_id })

    if err ~= nil then
      error(err, 0)
    end
  end,
})

rex.bind('ctrl+shift+w', 'close_pane_or_tab')

-- Panes - Resize -------------------------------------------------------------

local function first_block(node)
  while node.split do
    node = node.split.before
  end

  return node.block_id
end

local function find_split(node, block_id, axis)
  if node.block_id then
    return node.block_id == block_id, nil
  end

  local split = node.split

  for _, side in ipairs({ 'before', 'after' }) do
    local found, match = find_split(split[side], block_id, axis)

    if found then
      if match == nil and split.direction == axis then
        match = { split = split, side = side }
      end

      return true, match
    end
  end

  return false, nil
end

rex.action({
  name = 'resize_focused',
  title = 'Resize Focused Pane',
  args = { axis = 'string', amount = 'number' },
  run = function(ctx, args)
    local view, err = rex.session.view({ session_id = ctx.session_id })

    if err ~= nil then
      error(err, 0)
    end

    for _, window in ipairs(view.windows or {}) do
      for _, layer in ipairs(window.layers or {}) do
        if layer.kind == 'tiled' and layer.layout then
          local found, match = find_split(layer.layout, ctx.block_id, args.axis)

          if found then
            if match == nil then
              return
            end

            local split = match.split
            local before, after, ratio

            if match.side == 'before' then
              before, after, ratio = ctx.block_id, first_block(split.after), split.ratio + args.amount
            else
              before, after, ratio = first_block(split.before), ctx.block_id, split.ratio - args.amount
            end

            local _, resize_err = rex.session.resize_pane({
              session_id = ctx.session_id,
              direction = args.axis,
              before_block_id = before,
              after_block_id = after,
              ratio = math.min(math.max(ratio, 0.05), 0.95),
            })

            if resize_err ~= nil then
              error(resize_err, 0)
            end

            return
          end
        end
      end
    end
  end,
})

rex.bind('ctrl+shift+alt+n', 'resize_focused', { axis = 'horizontal', amount = -0.05 })
rex.bind('ctrl+shift+alt+s', 'resize_focused', { axis = 'vertical', amount = -0.05 })
rex.bind('ctrl+shift+alt+t', 'resize_focused', { axis = 'vertical', amount = 0.05 })
rex.bind('ctrl+shift+alt+w', 'resize_focused', { axis = 'horizontal', amount = 0.05 })

-- Panes - Layouts ------------------------------------------------------------

rex.action({
  name = 'unzoom',
  title = 'Restore Split Layout',
  run = function(ctx, args)
    local _, err = rex.session.zoom_block({ block_id = ctx.block_id, zoom = false })

    if err ~= nil then
      error(err, 0)
    end
  end,
})

rex.bind('ctrl+shift+f10', 'unzoom')
rex.bind('ctrl+shift+f12', 'pane.zoom')

-- Tabs -----------------------------------------------------------------------

rex.bind('ctrl+shift+t', 'client.tab.new')

rex.bind('ctrl+shift+[', 'client.tab.previous')
rex.bind('ctrl+shift+]', 'client.tab.next')

-- Launch ---------------------------------------------------------------------

rex.action({
  name = 'split_run',
  title = 'Run Command in Split',
  args = { direction = 'string', command = 'array' },
  run = function(ctx, args)
    local _, err = rex.session.new_split({
      anchor_id = ctx.block_id,
      direction = args.direction,
      side = 'after',
      focus = true,
      layout = rex.layout.block({
        flavor = SHELL,
        options = { command = args.command, cwd = current_cwd(ctx.block_id) },
      }),
    })

    if err ~= nil then
      error(err, 0)
    end
  end,
})

rex.action({
  name = 'project_tab',
  title = 'Open Project Tab',
  args = { label = 'string', path = 'string' },
  run = function(ctx, args)
    local _, err = rex.session.new_window({
      window_label = args.label,
      layout = rex.layout.block({ flavor = SHELL, options = { cwd = HOME .. '/' .. args.path } }),
    })

    if err ~= nil then
      error(err, 0)
    end
  end,
})

local ai = { 'zsh', '-il', '-c', 'ai' }
local yazi = { 'zsh', '-il', '-c', 'yazi $(head -n 1 "$HOME/.config/yazi-path" 2>/dev/null)' }
local gh_fzf = HOME .. '/personal/dotfiles/scripts/gh-fzf/'

rex.bind('ctrl+shift+a>v', 'split_run', { direction = 'horizontal', command = ai })
rex.bind('ctrl+shift+a>x', 'split_run', { direction = 'vertical', command = ai })

rex.bind('ctrl+shift+g>m', 'split_run', { direction = 'vertical', command = { gh_fzf .. 'gh-fzf-me.sh' } })
rex.bind(
  'ctrl+shift+g>r',
  'split_run',
  { direction = 'vertical', command = { gh_fzf .. 'gh-fzf-review-requested.sh' } }
)

rex.bind('ctrl+shift+y>v', 'split_run', { direction = 'horizontal', command = yazi })
rex.bind('ctrl+shift+y>x', 'split_run', { direction = 'vertical', command = yazi })

rex.bind('ctrl+shift+1', 'project_tab', { label = 'afp', path = 'work/afp/afp/main' })
rex.bind('ctrl+shift+2', 'project_tab', { label = 'monolith', path = 'work/agf/monolith' })

rex.bind('ctrl+shift+9', 'project_tab', { label = 'server', path = 'personal/server' })
rex.bind('ctrl+shift+0', 'project_tab', { label = 'dotfiles', path = 'personal/dotfiles' })

-- Sessions -------------------------------------------------------------------

rex.bind('ctrl+shift+/', 'session.switch')

rex.bind('f7>q', 'session.close')

rex.bind('f7>f7', 'pane.send_key', { key = 'f7' })

-- Miscellaneous --------------------------------------------------------------

rex.bind('cmd+k', 'pane.send_key', { key = 'ctrl+l' })

-- Miscellaneous - NOP --------------------------------------------------------

-- Unbound keys reach the terminal with their native encoding; pane.send_key
-- does not deliver cmd+* to Neovim as <D-*>.

rex.unbind('cmd+enter')
rex.unbind('cmd+n')
rex.unbind('cmd+t')

rex.unbind('cmd+w')

rex.unbind('cmd+f')
rex.unbind('cmd+g')
rex.unbind('cmd+p')
rex.unbind('cmd+r')

rex.unbind('ctrl+shift+tab')
rex.unbind('ctrl+tab')

-- Scrollback -----------------------------------------------------------------

rex.action({
  name = 'scrollback_nvim',
  title = 'Open Scrollback in Neovim',
  keywords = 'scrollback capture copy pager nvim',
  run = function(ctx, args)
    local script = [[
f=$(mktemp -t rex-scrollback)
rex capture -s "$1" -b "$2" --unwrap --trim > "$f"
nvim + "$f"
rm -f "$f"
]]
    local _, err = rex.session.new_layer({
      bounds = { 0, 0, 1, 1 },
      focus = true,
      layout = rex.layout.block({
        flavor = SHELL,
        options = { command = { 'sh', '-c', script, 'sh', ctx.session_id, ctx.block_id } },
      }),
    })

    if err ~= nil then
      error(err, 0)
    end
  end,
})

rex.bind('ctrl+shift+p', 'scrollback_nvim')

-- Mermaid --------------------------------------------------------------------

require('mermaid')

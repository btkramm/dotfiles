return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',

  opts = {
    keymap = { preset = 'super-tab' },

    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },

      providers = {
        lazydev = { module = 'lazydev.integrations.blink', name = 'LazyDev' },
      },
    },

    completion = {
      documentation = {
        auto_show = true,

        window = { border = 'rounded' },
      },

      menu = {
        border = 'rounded',

        draw = {
          gap = 0,
          padding = 0,

          components = {
            kind_icon = {
              text = function(ctx)
                return ' ' .. ctx.kind_icon .. ctx.icon_gap .. ' '
              end,
            },
          },
        },
      },
    },

    signature = {
      window = { border = 'rounded' },
    },
  },

  opts_extend = { 'sources.default' },
}

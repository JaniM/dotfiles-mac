return {
  -- I really dislike noice's notifications
  {
    "folke/noice.nvim",
    enabled = false,
  },

  -- add gruvbox
  { "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["l"] = "open",
        },
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          cmp.select_next_item()
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      -- Prevent cmp from preselecting the first item, allowing us to hit Enter normally.
      opts.preselect = cmp.PreselectMode.None
      opts.completion.completeopt = "menu,menuone,noselect"

      return opts
    end,
  },
}

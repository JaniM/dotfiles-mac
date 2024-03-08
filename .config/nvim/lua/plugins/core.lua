return {
  -- I really dislike noice's notifications
  {
    "folke/noice.nvim",
    enabled = false,
  },
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  {
    -- Press s for forward leap, S for backward leap
    "ggandor/leap.nvim",
    name = "leap",
    config = function()
      local leap = require("leap")
      -- remove symbols from the default labels
      leap.opts.safe_labels = "sfnut-SFNLHMUGTZ?"
      leap.opts.labels = "sfnjklhodweimbuyvrgtaqpcxz-SFNJKLHODWEIMBUYVRGTAQPCXZ"
      leap.add_default_mappings()
    end,
  },

  -- Note: copilut.lua depends on nodejs
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
}

-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
  { "ellisonleao/gruvbox.nvim" },
  { "tpope/vim-surround" },
  {
    -- Note: copilut.lua depends on nodejs
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
        panel = { enabled = false }
      })
    end
  },
  { "mfussenegger/nvim-jdtls" },
}

-- Disable default jdtls since it just doesn't work with lombok
-- You still need to run :LspInstall jdtls, copy
-- ~/.local/share/lvim/mason/packages/jdtls -> ~/.local/share/lvim/jdtls/
-- and :LspUninstall jdtls
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })

lvim.colorscheme = "gruvbox"
vim.opt.wrap = true

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "black" },
}

vim.api.nvim_create_user_command("Cppath", function()
  local path = vim.fn.expand("%:p")
  path = vim.fn.fnamemodify(path, ":~:.")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("Session", function()
  vim.api.nvim_command('TermExec cmd="tmux-sessionizer && exit"')
end, {})

vim.keymap.set('i', 'jj', '<Esc>')


-- Below config is required to prevent copilot overriding Tab with a suggestion
-- when you're just trying to indent!
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end
local on_tab = vim.schedule_wrap(function(fallback)
  local cmp = require("cmp")
  if cmp.visible() and has_words_before() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  else
    fallback()
  end
end)
lvim.builtin.cmp.mapping["<Tab>"] = on_tab


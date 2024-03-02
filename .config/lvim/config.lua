-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

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


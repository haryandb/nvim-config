local function copy_ai_context_format()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'x', true)

  local relative_path = vim.fn.expand('%:.')

  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  local formatted_string = string.format("%s:L%d-%d", relative_path, start_line, end_line)

  vim.fn.setreg('+', formatted_string)

  vim.notify("Copied: " .. formatted_string, vim.log.levels.INFO)
end

vim.keymap.set('v', '<leader>aix', copy_ai_context_format, { desc = "Copy file path and line range for AI" })

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳ "

-- Guicursor eksplisit: block di normal/visual/command (trail kitty jadi
-- kotak solid & kelihatan), beam tipis di insert. Tanpa ini, plugin lain
-- (atau default nvim) bisa mengganti shape dan trail berubah jadi garis.
vim.opt.guicursor = {
  "n-v-c-sm:block",
  "i-ci-ve:ver25",
  "r-cr-o:hor20",
  "a:Cursor/lCursor",
}

vim.keymap.set('n', '<leader>wn', '<cmd>noa w<CR>', { desc = "Save without formatting" })

local wk_avail, wk = pcall(require, "which-key")
if wk_avail then
  wk.add({
    { "<leader>ai", group = "AI", mode = { "v" } },
    { "<leader>aix", desc = "Copy file path + line range", mode = { "v" } },
    { "<leader>w", group = "Save" },
    { "<leader>wn", desc = "Save without formatting" },
  })
end

-- Pulihkan buffer nvim setelah tmux-resurrect me-restart nvim.
-- resession sudah autosave per-cwd (astrocore sessions.autosave.cwd),
-- tinggal dimuat ulang saat nvim start tanpa argumen file.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("TmuxResurrectSession", { clear = true }),
  callback = function()
    if vim.fn.argc() ~= 0 then return end
    local ok, resession = pcall(require, "resession")
    if not ok then return end
    pcall(resession.load, vim.uv.cwd(), { dir = "dirsession", silence_errors = true })
  end,
})

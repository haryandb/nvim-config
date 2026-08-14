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

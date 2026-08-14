---@type LazySpec
return {
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      { "<leader>y", "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
      { "<leader>Y", "<cmd>Yazi cwd<cr>", desc = "Open yazi in nvim's working directory" },
    },
    opts = {
      open_for_directories = false,
      floating_window_scaling_factor = 0.9,
      yazi_floating_window_border = "rounded",
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
}

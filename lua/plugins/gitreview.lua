---@type LazySpec
return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    opts = {
      picker = "snacks",
      enable_builtin = true,
      default_remote = { "origin" },
      file_panel = {
        icons = function(name)
          local icon, hl = require("mini.icons").get("file", name)
          return icon, hl
        end,
      },
    },
    keys = {
      { "<leader>oi", "<cmd>Octo issue list<CR>", desc = "List GitHub Issues" },
      { "<leader>op", "<cmd>Octo pr list<CR>", desc = "List GitHub Pull Requests" },
      { "<leader>od", "<cmd>Octo discussion list<CR>", desc = "List GitHub Discussions" },
      { "<leader>on", "<cmd>Octo notification list<CR>", desc = "List GitHub Notifications" },
      { "<leader>os", "<cmd>Octo search<CR>", desc = "Search GitHub" },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Open diff view" },
      { "<leader>gV", "<cmd>DiffviewFileHistory<CR>", desc = "Git file history" },
    },
    opts = {
      use_icons = false,
    },
  },
}

---@type LazySpec
return {
  -- Git worktree switcher (create, delete, switch) via vim.ui.select
  {
    "afonsofrancof/worktrees.nvim",
    event = "VeryLazy",
    opts = {
      -- Worktree dibuat di parent directory dari .git (mis. ~/project-worktrees/...)
      base_path = "..",
      -- Template nama folder worktree: pakai nama branch
      path_template = "{branch}",
      commands = {
        create = "WorktreeCreate",
        delete = "WorktreeDelete",
        switch = "WorktreeSwitch",
      },
      mappings = {
        create = "<Leader>wtc",
        delete = "<Leader>wtd",
        switch = "<Leader>wts",
      },
      on_switch = function(from_path, to_path)
        require("astrocore").notify(("Switched worktree: %s → %s"):format(
          from_path and vim.fn.fnamemodify(from_path, ":t") or "unknown",
          vim.fn.fnamemodify(to_path, ":t")
        ))
      end,
    },
  },
}

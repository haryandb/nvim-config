---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      highlight = true,
      indent = true,
      auto_install = true,
      ensure_installed = {
        "lua",
        "vim",
        "php",
        "blade",
        "vue",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "css",
        "html",
      },
    },
  },
}

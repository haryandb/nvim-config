---@type LazySpec
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "latte",
      background = {
        light = "latte",
        dark = "mocha",
      },
    },
  },
}

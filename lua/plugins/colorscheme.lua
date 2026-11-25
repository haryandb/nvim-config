---@type LazySpec
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      background = {
        light = "latte",
        dark = "mocha",
      },
    },
  },
}

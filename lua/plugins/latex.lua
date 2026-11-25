-- LaTeX configuration: overrides for vimtex (loaded via astrocommunity.markdown-and-latex.vimtex)
---@type LazySpec
return {
  {
    "lervag/vimtex",
    -- Pin ke v2.17: rilis terbaru (v2.18) mensyaratkan Neovim >= 0.12.4,
    -- sedangkan nvim yang terpasang adalah 0.11.x
    version = "v2.17",
    init = function()
      -- == PDF Viewer: Preview.app (macOS default) ==
      -- NOTE: Preview.app does not support forward/backward sync.
      -- For sync support, install Skim and switch to:
      --   vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_method = "general"
      vim.g.vimtex_view_general_viewer = "open"
      vim.g.vimtex_view_general_options = "-a Preview @pdf"

      -- == Compiler: latexmk with XeLaTeX engine ==
      -- To use LuaLaTeX instead, change "-xelatex" to "-lualatex" below.
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        hooks = {},
        options = {
          "-xelatex",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      -- Quickfix: only open automatically on errors
      vim.g.vimtex_quickfix_mode = 2
    end,
  },
}

-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "vtsls",
        "vue-language-server",
        "typescript-language-server",
        "intelephense",
        "rust-analyzer",
        "taplo",
        "stylua",
        "pint",
        "prettier",
        "eslint_d",
        "blade-formatter",
        "debugpy",
        "php-debug-adapter",
        "tailwindcss-language-server",
        "html-lsp",
        "css-lsp",
        "emmet-ls",
        "json-lsp",
      },
    },
  },
}

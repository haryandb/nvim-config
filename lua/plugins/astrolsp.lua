-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {
          "dart",
          "php",
          "vue",
          "javascript",
          "typescript",
          "rust",
        },
        ignore_filetypes = {},
      },
      disabled = {
        "volar",
        "html",
        "emmet_ls",
      },
      timeout_ms = 20000,
    },
    servers = {
      "vtsls", -- Kita pertahankan vtsls karena performanya jauh lebih baik untuk Vue Hybrid
      "vue_ls",
      "intelephense",
      "rust_analyzer",
    },
    config = {
      html = {
        filetypes = { "html", "blade" },
      },
      emmet_ls = {
        filetypes = { "html", "blade", "vue", "css", "sass", "scss", "less", "javascriptreact", "typescriptreact" },
      },
      tailwindcss = {
        filetypes = { "html", "blade", "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
        settings = {
          tailwindCSS = {
            emmetCompletions = true,
            includeLanguages = {
              vue = "html",
              blade = "html",
            },
          },
        },
      },
      intelephense = {
        settings = {
          intelephense = {
            files = {
              maxSize = 1000000,
            },
          },
        },
      },
      vue_ls = {
        init_options = {
          vue = {
            hybridMode = true,
          },
          typescript = {
            tsdk = vim.fn.stdpath("data") .. "/mason/packages/vtsls/node_modules/typescript/lib"
          },
        },
        settings = {
          vue = {
            complete = { casing = { props = "camel" } },
          },
        },
        filetypes = { "vue" }, -- Kembalikan ke default agar tidak berebut file murni .ts/.js
      },
      vtsls = {
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        settings = {
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
            documentHighlight = { enabled = false },
          },
          typescript = {
            tsdk = "node_modules/typescript/lib",
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
      },
    },
    handlers = {},
    autocmds = {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh({ bufnr = args.buf }) end
          end,
        },
      },
      format_dart_on_save = {
        cond = function(client, bufnr) return vim.bo[bufnr].filetype == "dart" end,
        {
          event = { "BufWritePre" },
          desc = "Format Dart file on save using DartFmt",
          callback = function(args) vim.cmd "DartFmt" end,
        },
      },
    },
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    on_attach = function(client, bufnr)
      if client.name == "vtsls" then
        client.server_capabilities.documentHighlightProvider = false
      end
    end,
  },
}

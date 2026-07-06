-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup {
        easing_function = "quadratic",
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = true,
        cursor_scrolls_alone = true,
        performance_mode = false,
      }
    end,
  },

  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<S-h>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
          ["<S-l>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        },
      },
    },
  },

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })

      -- include the default astronvim config that calls the setup call
      require "astronvim.plugins.configs.luasnip"(plugin, opts)

      -- Vue 3 Composition API snippets
      luasnip.add_snippets("vue", {
        luasnip.snippet("vsetup", {
          luasnip.text_node("<script setup lang=\"ts\">"),
          luasnip.insert_node(1),
          luasnip.text_node("\n</script>\n\n<template>"),
          luasnip.insert_node(2),
          luasnip.text_node("\n</template>\n\n<style scoped>"),
          luasnip.insert_node(3),
          luasnip.text_node("\n</style>"),
        }),
        luasnip.snippet("vref", {
          luasnip.text_node("const "),
          luasnip.insert_node(1, "val"),
          luasnip.text_node(" = ref<"),
          luasnip.insert_node(2, "type"),
          luasnip.text_node(">("),
          luasnip.insert_node(3),
          luasnip.text_node(")"),
        }),
        luasnip.snippet("vcomputed", {
          luasnip.text_node("const "),
          luasnip.insert_node(1, "val"),
          luasnip.text_node(" = computed(() => "),
          luasnip.insert_node(2),
          luasnip.text_node(")"),
        }),
        luasnip.snippet("vprops", {
          luasnip.text_node("const props = defineProps<{"),
          luasnip.insert_node(1),
          luasnip.text_node("}>()"),
        }),
        luasnip.snippet("vemit", {
          luasnip.text_node("const emit = defineEmits<{"),
          luasnip.insert_node(1),
          luasnip.text_node("}>()"),
        }),
        luasnip.snippet("vamounted", {
          luasnip.text_node("onMounted(() => "),
          luasnip.insert_node(1),
          luasnip.text_node(")"),
        }),
        luasnip.snippet("vwatch", {
          luasnip.text_node("watch(() => "),
          luasnip.insert_node(1, "source"),
          luasnip.text_node(", ("),
          luasnip.insert_node(2, "val"),
          luasnip.text_node(") => "),
          luasnip.insert_node(3),
          luasnip.text_node(")"),
        }),
        luasnip.snippet("vreactive", {
          luasnip.text_node("const "),
          luasnip.insert_node(1, "state"),
          luasnip.text_node(" = reactive<"),
          luasnip.insert_node(2, "type"),
          luasnip.text_node(">({"),
          luasnip.insert_node(3),
          luasnip.text_node("})"),
        }),
      })

      -- Inertia.js snippets
      luasnip.add_snippets("vue", {
        luasnip.snippet("ilink", {
          luasnip.text_node("<Link href=\""),
          luasnip.insert_node(1),
          luasnip.text_node("\""),
          luasnip.insert_node(2),
          luasnip.text_node(">"),
          luasnip.insert_node(3),
          luasnip.text_node("</Link>"),
        }),
        luasnip.snippet("irget", {
          luasnip.text_node("router.get(\""),
          luasnip.insert_node(1),
          luasnip.text_node("\", "),
          luasnip.insert_node(2),
          luasnip.text_node(")"),
        }),
        luasnip.snippet("irpost", {
          luasnip.text_node("router.post(\""),
          luasnip.insert_node(1),
          luasnip.text_node("\", "),
          luasnip.insert_node(2),
          luasnip.text_node(")"),
        }),
        luasnip.snippet("iform", {
          luasnip.text_node("const form = useForm({"),
          luasnip.insert_node(1),
          luasnip.text_node("})"),
        }),
        luasnip.snippet("ipage", {
          luasnip.text_node("const page = usePage<"),
          luasnip.insert_node(1),
          luasnip.text_node(">()"),
        }),
      })

      -- Tauri API snippets
      luasnip.add_snippets("vue", {
        luasnip.snippet("tinvoke", {
          luasnip.text_node("await invoke(\""),
          luasnip.insert_node(1, "command"),
          luasnip.text_node("\", { "),
          luasnip.insert_node(2),
          luasnip.text_node(" })"),
        }),
        luasnip.snippet("tlisten", {
          luasnip.text_node("await listen(\""),
          luasnip.insert_node(1, "event"),
          luasnip.text_node("\", (event) => "),
          luasnip.insert_node(2),
          luasnip.text_node(")"),
        }),
        luasnip.snippet("temit", {
          luasnip.text_node("await emit(\""),
          luasnip.insert_node(1, "event"),
          luasnip.text_node("\", "),
          luasnip.insert_node(2),
          luasnip.text_node(")"),
        }),
      })

      -- Tauri Rust snippets
      luasnip.add_snippets("rust", {
        luasnip.snippet("tcmd", {
          luasnip.text_node("#[tauri::command]\nfn "),
          luasnip.insert_node(1, "command_name"),
          luasnip.text_node("("),
          luasnip.insert_node(2),
          luasnip.text_node(") -> Result<(), String> {\n    "),
          luasnip.insert_node(3),
          luasnip.text_node("\n}"),
        }),
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}

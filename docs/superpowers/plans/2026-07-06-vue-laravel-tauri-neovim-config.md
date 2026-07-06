# Vue.js for Laravel & Tauri — Neovim Config Implementation Plan

> **For agentic workers:** Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Optimize AstroNvim config for Vue.js development in Laravel (Inertia + SPA) and Tauri (Vue + TS + Vite) projects.

**Architecture:** Two-file change: (1) `astrolsp.lua` — fix vtsls/vue_ls LSP coexistence, (2) `user.lua` — add custom LuaSnip snippets for Vue 3 Composition API, Inertia.js, and Tauri API.

**Tech Stack:** AstroNvim, LuaSnip, vue_ls (Vue Language Server), vtsls (TypeScript), Tailwind CSS LSP

## Global Constraints

- Keep existing Mason tools unchanged (all needed tools already installed)
- Follow existing AstroNvim plugin config patterns
- Snippets use LuaSnip format
- LSP changes must not break existing functionality

---

### Task 1: Fix LSP Coexistence (vtsls + vue_ls)

**Files:**
- Modify: `lua/plugins/astrolsp.lua` — vtsls filetypes and vue_ls config

- [ ] **Step 1: Remove "vue" from vtsls filetypes**

In `lua/plugins/astrolsp.lua`, change vtsls filetypes to exclude `"vue"`:

```lua
vtsls = {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
```

- [ ] **Step 2: Verify file**

Check the final astrolsp.lua has:
- vtsls filetypes without "vue"
- vue_ls filetypes = `{ "vue" }`
- vue_ls hybrid mode enabled pointing to vtsls tsdk

---

### Task 2: Add Custom Vue 3 / Inertia / Tauri Snippets

**Files:**
- Modify: `lua/plugins/user.lua` — add LuaSnip snippets

- [ ] **Step 1: Add Vue 3 Composition API snippets**

In `lua/plugins/user.lua`, inside the LuaSnip config block, add snippets:

```lua
-- Vue 3 Composition API snippets
luasnip.add_snippets("vue", {
    -- <script setup lang="ts">
    luasnip.snippet("vsetup", {
        luasnip.text_node("<script setup lang=\"ts\">"),
        luasnip.insert_node(1),
        luasnip.text_node("\n</script>\n\n<template>"),
        luasnip.insert_node(2),
        luasnip.text_node("\n</template>\n\n<style scoped>"),
        luasnip.insert_node(3),
        luasnip.text_node("\n</style>"),
    }),
    -- ref
    luasnip.snippet("vref", {
        luasnip.text_node("const "),
        luasnip.insert_node(1, "val"),
        luasnip.text_node(" = ref<"),
        luasnip.insert_node(2, "type"),
        luasnip.text_node(">("),
        luasnip.insert_node(3),
        luasnip.text_node(")"),
    }),
    -- computed
    luasnip.snippet("vcomputed", {
        luasnip.text_node("const "),
        luasnip.insert_node(1, "val"),
        luasnip.text_node(" = computed(() => "),
        luasnip.insert_node(2),
        luasnip.text_node(")"),
    }),
    -- props
    luasnip.snippet("vprops", {
        luasnip.text_node("const props = defineProps<{"),
        luasnip.insert_node(1),
        luasnip.text_node("}>()"),
    }),
    -- emit
    luasnip.snippet("vemit", {
        luasnip.text_node("const emit = defineEmits<{"),
        luasnip.insert_node(1),
        luasnip.text_node("}>()"),
    }),
    -- onMounted
    luasnip.snippet("vamounted", {
        luasnip.text_node("onMounted(() => "),
        luasnip.insert_node(1),
        luasnip.text_node(")"),
    }),
    -- watch
    luasnip.snippet("vwatch", {
        luasnip.text_node("watch(() => "),
        luasnip.insert_node(1, "source"),
        luasnip.text_node(", ("),
        luasnip.insert_node(2, "val"),
        luasnip.text_node(") => "),
        luasnip.insert_node(3),
        luasnip.text_node(")"),
    }),
    -- reactive
    luasnip.snippet("vreactive", {
        luasnip.text_node("const state = reactive<"),
        luasnip.insert_node(1, "type"),
        luasnip.text_node(">({"),
        luasnip.insert_node(2),
        luasnip.text_node("})"),
    }),
}),

-- Inertia.js snippets
luasnip.add_snippets("vue", {
    -- Link
    luasnip.snippet("ilink", {
        luasnip.text_node("<Link href=\""),
        luasnip.insert_node(1),
        luasnip.text_node("\""),
        luasnip.insert_node(2),
        luasnip.text_node(">"),
        luasnip.insert_node(3),
        luasnip.text_node("</Link>"),
    }),
    -- router.get
    luasnip.snippet("irget", {
        luasnip.text_node("router.get(\""),
        luasnip.insert_node(1),
        luasnip.text_node("\", "),
        luasnip.insert_node(2),
        luasnip.text_node(")"),
    }),
    -- router.post
    luasnip.snippet("irpost", {
        luasnip.text_node("router.post(\""),
        luasnip.insert_node(1),
        luasnip.text_node("\", "),
        luasnip.insert_node(2),
        luasnip.text_node(")"),
    }),
    -- useForm
    luasnip.snippet("iform", {
        luasnip.text_node("const form = useForm({"),
        luasnip.insert_node(1),
        luasnip.text_node("})"),
    }),
    -- usePage
    luasnip.snippet("ipage", {
        luasnip.text_node("const page = usePage<"),
        luasnip.insert_node(1),
        luasnip.text_node(">()"),
    }),
})

-- Tauri API snippets (Vue/TS context)
luasnip.add_snippets("vue", {
    -- invoke
    luasnip.snippet("tinvoke", {
        luasnip.text_node("await invoke(\""),
        luasnip.insert_node(1, "command"),
        luasnip.text_node("\", { "),
        luasnip.insert_node(2),
        luasnip.text_node(" })"),
    }),
    -- listen
    luasnip.snippet("tlisten", {
        luasnip.text_node("await listen(\""),
        luasnip.insert_node(1, "event"),
        luasnip.text_node("\", (event) => "),
        luasnip.insert_node(2),
        luasnip.text_node(")"),
    }),
    -- emit
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
    -- #[tauri::command]
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
```

- [ ] **Step 2: Verify syntax**

Run: `nvim --headless "+lua require('luasnip')" "+q"` to verify no load errors.

---

### Task 3: Verify Tailwind CSS LSP in Vue Files

**Files:**
- Modify: `lua/plugins/astrolsp.lua` — tailwindcss server config

- [ ] **Step 1: Add tailwindcss filetypes override**

In `lua/plugins/astrolsp.lua`, inside the `config` table, add:

```lua
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
```

---

### Verification

- [ ] Restart Neovim: `nvim some-file.vue`
- [ ] Test: both vue_ls and vtsls attach without conflicts (`:LspInfo`)
- [ ] Test: Vue snippets work (`vsetup`, `vref`, `vprops`, etc.)
- [ ] Test: Inertia snippets work (`ilink`, `iform`, `ipage`)
- [ ] Test: Tauri snippets work (`tinvoke`, `tlisten`, `tcmd`)
- [ ] Test: Tailwind CSS class completion in `.vue` `<template>`

# Neovim AstroNvim Config: Vue.js for Laravel & Tauri

## Context

AstroNvim Neovim config needs optimization for Vue.js development in two contexts:
- **Laravel**: Vue SFC + Inertia.js inside Blade/Laravel projects
- **Tauri**: Vue 3 + TypeScript + Vite desktop apps

## Changes

### 1. LSP Coexistence (vtsls + vue_ls)

Remove `"vue"` from vtsls filetypes so vue_ls handles all `.vue` files via hybrid mode (using vtsls as TS backend).

**astrolsp.lua** changes:
- vtsls filetypes: remove `"vue"`, keep `{ "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }`
- vue_ls: keep hybrid mode with vtsls tsdk, keep filetypes `{ "vue" }`
- Formatting: vue_ls handles `.vue`, vtsls handles `.ts/.js`

### 2. Custom Vue/Inertia/Tauri Snippets

Add LuaSnip snippets to `lua/plugins/user.lua` (or new `lua/snippets/`):

| Trigger | Expansion | Context |
|---------|-----------|---------|
| `vsetup` | `<script setup lang="ts">` block | `.vue` |
| `vref` | `const val = ref<T>()` | `.vue,.ts` |
| `vcomputed` | `const val = computed(() => )` | `.vue,.ts` |
| `vprops` | `defineProps<{}>()` | `.vue` |
| `vemit` | `const emit = defineEmits<{}>()` | `.vue` |
| `ilink` | `<Link href="" />` | `.vue` |
| `iroute` | `router.get/post/put/delete()` | `.vue,.ts` |
| `iform` | `useForm({})` | `.vue,.ts` |
| `ipage` | `usePage<{}>()` | `.vue,.ts` |
| `tinvoke` | `invoke("<cmd>", {})` | `.vue,.ts` |
| `tlisten` | `listen("event", ()=>{})` | `.vue,.ts` |
| `tcmd` | `#[tauri::command] fn cmd(){}` | `.rs` |

### 3. Tailwind CSS LSP in Vue Files

Ensure `tailwindcss-language-server` handles `.vue` files (already installed via Mason).

## Files Modified

- `lua/plugins/astrolsp.lua` — LSP filetypes config
- `lua/plugins/user.lua` — custom snippets

## Success Criteria

- No duplicate LSP diagnostics in `.vue` files
- Vue 3 Composition API snippets expand correctly
- Inertia.js snippets work in `.vue` files
- Tauri snippets work in `.vue` and `.rs` files
- Tailwind CSS class autocompletion in `.vue` templates

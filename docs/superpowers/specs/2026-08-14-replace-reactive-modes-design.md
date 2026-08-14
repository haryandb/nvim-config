# Replace reactive.nvim with modes.nvim

Date: 2026-08-14

## Problem

The `reactive.nvim` plugin is configured with `builtin.cursorline = true` in
`lua/plugins/user.lua`. Its `cursorline` preset hardcodes dark-theme colors
(e.g. `CursorLine bg #21202e`, `Visual bg #3b0764`) via window-local `winhl`,
overriding the light colors of `github_light_default`. As a result:

- The active line (`CursorLine`) renders near-black on the light editor
  background, making text nearly unreadable.
- Picker lists (snacks picker maps `CursorLine → Visual`), `QuickFixLine`, and
  `TelescopeSelection` inherit the same dark background with dark text.

A previous attempt to override the colors via `configs.cursorline` was not fully
effective because reactive's window-local `winhl` conflicts with the
`winhighlight` set by the snacks picker list window.

## Goal

Replace `reactive.nvim` with `modes.nvim` (mvllow/modes.nvim) so that mode-based
highlights work correctly on the light theme. The following features must be
preserved:

- CursorLine changes color per mode (normal/insert/visual/replace).
- Cursor color changes per mode (via `guicursor`).
- Operator highlights for `d` (delete), `c` (change), `y` (copy).
- Mode message highlighting (`ModeMsg`) when `showmode` is on.

## Solution

### Files changed

- `lua/plugins/user.lua`

### Changes

1. Remove the `rasulomaroff/reactive.nvim` spec and its entire
   `configs.cursorline` override block (currently lines 67-155).
2. Add a `modes.nvim` spec:

   ```lua
   {
     "mvllow/modes.nvim",
     event = "UIEnter",
     config = function()
       require("modes").setup {
         set_cursor = true,     -- cursor color per mode
         set_cursorline = true, -- cursorline per mode
         set_number = true,     -- line numbers follow cursorline
         set_signcolumn = true, -- signcolumn follows cursorline
         ignore = {
           "NvimTree",
           "TelescopePrompt",
           "TelescopeResults",
           "snacks_picker_list",
           "snacks_picker_input",
         },
       }
     end,
   }
   ```

### Why modes.nvim is safe on the light theme

- modes.nvim blends each mode color against the `bg` of the `Normal` highlight
  group (from `github_light_default` = `#ffffff`) using `line_opacity = 0.15`.
  Resulting backgrounds are always light pastel tints, never dark.
- It re-defines its highlights on every `ColorScheme` change, so theme switches
  are handled automatically.
- AstroNvim defines no normal-mode mappings with a `d` or `y` prefix, so the
  known which-key conflict for operator highlights does not apply.
- The snacks picker list/input buffers are ignored so picker selection
  highlights are not disturbed.

### Plugin synchronization

Run `:Lazy sync` (or `:Lazy clean`) so lazy.nvim removes reactive.nvim and
installs modes.nvim. `lazy-lock.json` is updated automatically.

## Verification

- nvim loads without errors.
- In normal mode, `CursorLine` background stays light (`#e7eaf0`-style tint).
- In insert mode, `CursorLine` background becomes a light teal tint.
- `ModeMsg` is linked to `Modes*ModeMsg` groups while `showmode` is on.
- Snacks picker selection remains readable (light background).

## Out of scope

- No other plugin configuration is changed.
- No keybindings are added or removed.

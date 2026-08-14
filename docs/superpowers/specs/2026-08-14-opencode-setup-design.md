# Setup opencode.nvim

Date: 2026-08-14

## Goal

Integrate [opencode.nvim](https://github.com/nickjvandyke/opencode.nvim) into the
AstroNvim v6 configuration so OpenCode pairing works from Neovim with the
project's existing plugins (snacks.nvim, blink.cmp, heirline statusline).

## Features to enable

- Ask: input a prompt with context completion (`ask()`).
- Select: picker over prompts/commands/servers (`select()`).
- Operator: append a range/selection to OpenCode (`operator()`).
- Server: start `opencode --port` inside a snacks.terminal panel on the right.
- blink.cmp: LSP + buffer completion in the `opencode_ask` filetype.
- Snacks picker → OpenCode: send selected picker items to a prompt.
- Statusline: show connected server + status icon via heirline.

## Implementation

### New file: `lua/plugins/opencode.lua`

Single LazySpec returning a table that adds the plugin and its integrations.

```lua
---@type LazySpec
return {
  -- opencode.nvim itself
  {
    "nickjvandyke/opencode.nvim",
    version = "*", -- latest stable release
    event = "VeryLazy",
    config = function()
      local opencode_cmd = "opencode --port"

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            require("snacks.terminal").open(opencode_cmd, {
              win = { position = "right", enter = false },
            })
          end,
        },
      }

      -- Show the opencode terminal when a prompt is submitted
      vim.api.nvim_create_autocmd("User", {
        pattern = { "OpencodeEvent:tui.command.execute" },
        callback = function(args)
          ---@type opencode.server.Event
          local event = args.data.event
          if event.properties.command == "prompt.submit" then
            local win = require("snacks.terminal").get(opencode_cmd, { create = false })
            if win then win:show() end
          end
        end,
      })
    end,
  },

  -- blink.cmp: enable LSP + buffer completion in opencode_ask
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          opencode_ask = { "lsp", "buffer" },
        },
      },
    },
  },

  -- snacks.picker: send selected items to an OpenCode prompt
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        win = {
          input = {
            keys = {
              ["<a-o>"] = { "opencode_send", mode = { "n", "i" } },
            },
          },
        },
        actions = {
          opencode_send = function(picker) ---@param picker snacks.Picker
            local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
              return item.file
                  and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                or item.text
            end, picker:selected({ fallback = true }))
            require("opencode").prompt(table.concat(items, ", ") .. " ")
          end,
        },
      },
    },
  },

  -- heirline statusline: show connected opencode server + status
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      -- insert an opencode component before the right-side mode component
      local status = require "astroui.status"
      local components = opts.statusline or {}
      local mode_comp = components[#components]
      components[#components] = {
        provider = function() return require("opencode").statusline() end,
        update = { "User", pattern = "OpencodeEvent:*", callback = nil },
        hl = { fg = "fg", bg = "bg" },
      }
      table.insert(components, mode_comp)
      return opts
    end,
  },
}
```

### Keymaps — merged into the existing AI group

The existing AI group lives in `lua/polish.lua` (`<leader>ai` group, `<leader>aix`
for AI context copy). Add the following to `lua/plugins/opencode.lua` or `polish.lua`
via which-key group entries:

| Keymap | Action | Modes |
|---|---|---|
| `<leader>aa` | `require("opencode").ask("@this: ")` | n, x |
| `<leader>as` | `require("opencode").select()` | n, x |
| `<leader>ao` | `operator("@this ")` (append range) | n, x |
| `<leader>aol` | `operator("@this ") .. "_"` (append line) | n |
| `<leader>at` | toggle opencode terminal | n, t |

which-key group labels: add `<leader>a` (or extend existing `ai` group) with
descriptions for each key.

## Notes

- AstroNvim v6 uses heirline for the statusline, not lualine, so the
  `require("opencode").statusline` lualine example from the README must be
  adapted as a heirline component.
- `vim.g.opencode_opts` is read by the plugin at load time; because snacks
  metatables are not supported in `vim.g`, keep the config to plain tables.
- AstroNvim defines no `d`/`y` prefix or `go` mappings, so no keymap conflicts
  with the recommended bindings (already verified).

## Verification

- `:Lazy sync` installs opencode.nvim without errors.
- `:checkhealth opencode` passes (opencode binary + server reachable).
- `<leader>as` opens the snacks picker with prompts/commands/servers.
- `<leader>aa` opens an `opencode_ask` input with blink.cmp completion.
- Statusline shows the opencode icon + server.
- `<a-o>` in the snacks picker sends the selected item to a prompt.

## Out of scope

- No changes to the TUI behavior of OpenCode itself.
- No changes to existing keymaps outside the AI group.

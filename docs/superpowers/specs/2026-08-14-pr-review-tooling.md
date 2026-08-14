# Design: PR Review Tooling

## Goal

Add tooling to review GitHub pull requests from inside Neovim:
- Browse and review GitHub PRs/issues with comments and reviews (octo.nvim)
- Diff viewer between branches/commits (diffview.nvim)
- Stage/unstage hunks (already covered by AstroNvim's built-in gitsigns)

## Approach

Create `lua/plugins/gitreview.lua` with two Lazy specs.

### octo.nvim

- `cmd = "Octo"` lazy-load
- Dependencies: `plenary.nvim`, `snacks.nvim` (both already installed); picker = `snacks`
- `enable_builtin = true` so bare `:Octo` opens an action list
- `default_remote = { "origin" }` (repo only has `origin`)
- File panel icons via `mini.icons` (AstroNvim v6 does not ship nvim-web-devicons)
- Keymaps (prefix `<Leader>o` to avoid the crowded `<Leader>g` git group):
  - `<Leader>oi` -> `Octo issue list`
  - `<Leader>op` -> `Octo pr list`
  - `<Leader>od` -> `Octo discussion list`
  - `<Leader>on` -> `Octo notification list`
  - `<Leader>os` -> `Octo search`

Review flow inside octo buffers (default octo keymaps):
`<CR>` PR options, `<localleader>pf` changed files, `<localleader>pd` PR diff,
`<leader>qa` approve, `<localleader>vs` submit review.

### diffview.nvim

- `use_icons = false` (avoids nvim-web-devicons dependency)
- Keymaps:
  - `<Leader>gv` -> `DiffviewOpen`
  - `<Leader>gV` -> `DiffviewFileHistory`

### Stage/unstage

Already satisfied by AstroNvim gitsigns (`<Leader>gs` stage hunk,
`<Leader>gS` stage buffer) and diffview file panel (`s`/`S`/`U`).

## Requirements

- `gh` CLI installed and authenticated (present, token scope `repo`)
- Neovim >= 0.10 (present)

## Verification

- `nvim --headless +qa` loads without errors
- `:checkhealth octo` passes

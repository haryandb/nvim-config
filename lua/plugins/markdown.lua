---@type LazySpec
return {
  -- Render teks markdown (heading, tabel, list, checkbox, code block)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "octo" },
    opts = {
      -- Buffer octo (PR/issue) berisi markdown tapi filetype-nya "octo"
      file_types = { "markdown", "octo" },
      -- Render di normal/cmdline/terminal; insert mode berhenti (lihat teks mentah)
      render_modes = { "n", "c", "t" },
      -- Baris kursor ikut terender (default true justru menyembunyikan render di baris kursor)
      anti_conceal = { enabled = false },
      -- wrap=true membuat baris tabel yang terlalu lebar memakai mekanisme 'replace',
      -- yang SELALU disembunyikan saat kursor di barisnya (hardcoded di hide(),
      -- di luar kendali anti_conceal) -> baris tabel tampak tidak terender.
      -- wrap=false: semua baris tabel pakai overlay biasa, selalu terender.
      pipe_table = { wrap = false },
    },
    init = function()
      -- Daftarkan parser markdown untuk filetype octo, supaya
      -- vim.treesitter.get_parser() di buffer octo memakai parser markdown
      vim.treesitter.language.register("markdown", "octo")
    end,
  },

  -- Sembunyikan simbol markdown supaya tampilan rapi
  {
    "AstroNvim/astrocore",
    opts = {
      autocmds = {
        markdown_conceal = {
          {
            event = "FileType",
            pattern = "markdown",
            callback = function()
              vim.opt_local.conceallevel = 2
            end,
          },
        },
      },
    },
  },
}

---@type LazySpec
return {
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

      vim.keymap.set({ "n", "x" }, "<Leader>aa", function() require("opencode").ask("@this: ") end, { desc = "Ask OpenCode" })
      vim.keymap.set({ "n", "x" }, "<Leader>as", function() require("opencode").select() end, { desc = "Select OpenCode" })
      vim.keymap.set({ "n", "x" }, "<Leader>ao", function() return require("opencode").operator("@this ") end, { desc = "Append range to OpenCode", expr = true })
      vim.keymap.set("n", "<Leader>aol", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Append line to OpenCode", expr = true })
      vim.keymap.set({ "n", "t" }, "<Leader>at", function() require("snacks.terminal").toggle(opencode_cmd) end, { desc = "Toggle OpenCode terminal" })

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

      local wk_avail, wk = pcall(require, "which-key")
      if wk_avail then
        wk.add({
          { "<Leader>a", group = "OpenCode", mode = { "n", "x", "t" } },
          { "<Leader>aa", desc = "Ask OpenCode", mode = { "n", "x" } },
          { "<Leader>as", desc = "Select OpenCode", mode = { "n", "x" } },
          { "<Leader>ao", desc = "Append range to OpenCode", mode = { "n", "x" } },
          { "<Leader>aol", desc = "Append line to OpenCode", mode = { "n" } },
          { "<Leader>at", desc = "Toggle OpenCode terminal", mode = { "n", "t" } },
        })
      end
    end,
  },

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

  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local statusline = opts.statusline
      if not statusline or type(statusline) ~= "table" then return opts end

      local mode_comp = statusline[#statusline]

      statusline[#statusline] = {
        provider = function() return require("opencode").statusline() end,
        update = { "User", pattern = "OpencodeEvent:*" },
        hl = { fg = "fg", bg = "bg" },
      }
      table.insert(statusline, mode_comp)

      return opts
    end,
  },
}

-- ~/.config/nvim/lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  opts = {
    -- Map filetypes to formatters
    formatters_by_ft = {
      -- lua = { "stylua" },
      -- python = { "black" },
      -- javascript = { "prettierd", "prettier" }, -- fallbacks: try prettierd first
      -- typescript = { "prettierd", "prettier" },
      cs = { "csharpier" },
    },

    -- You can define custom formatter configs
    formatters = {
      csharpier = {
        command = "dotnet-csharpier",
        args = { "--write-stdout" },
      },
    },
  },

  -- config = function(_, opts)
  --   local conform = require("conform")
  --   conform.setup(opts)
  --
  --   -- Optional: autoformat on save
  --   -- vim.api.nvim_create_autocmd("BufWritePre", {
  --   --   pattern = "*",
  --   --   callback = function(args)
  --   --     conform.format({ bufnr = args.buf, lsp_fallback = true })
  --   --   end,
  --   -- })
  -- end,
}

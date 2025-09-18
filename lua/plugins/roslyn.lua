-- ~/.config/nvim/lua/plugins/roslyn.lua
return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- add custom registry so Mason knows about roslyn
      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
      })

      -- this both registers the lspconfig "roslyn" server
      -- and starts it when you open C# files
      require("roslyn").setup({
        filewatching = "roslyn",
        broad_search = true,
        silent = false,
        lsp = {
          on_attach = function(client, bufnr)
            local bufmap = function(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end
            bufmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
            bufmap("n", "gr", vim.lsp.buf.references, "Go to References")
          end,
          settings = {
            ["csharp|inlay_hints"] = {
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
            },
            ["csharp|code_lens"] = {
              dotnet_enable_references_code_lens = true,
              dotnet_enable_tests_code_lens = false,
            },
          },
        },
      })
    end,
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        progress = { enabled = false }, -- workaround for roslyn progress bug
      },
    },
  },
}

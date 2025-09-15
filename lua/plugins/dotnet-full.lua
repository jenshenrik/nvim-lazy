-- File: ~/.config/nvim/lua/plugins/dotnet-full.lua
return {
  -- 1️⃣ nvim-dap for debugging C# (netcoredbg)
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio", "ramboe/ramboe-dotnet-utils" },
    config = function()
      local dap = require("dap")

      -- path to netcoredbg installed via Mason
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
      local netcoredbg_adapter = {
        type = "executable",
        command = mason_path,
        args = { "--interpreter=vscode" },
      }

      dap.adapters.netcoredbg = netcoredbg_adapter
      dap.adapters.coreclr = netcoredbg_adapter

      -- DAP configuration for C#
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch .NET DLL",
          request = "launch",
          program = function()
            return require("dap-dll-autopicker").build_dll_path()
          end,
        },
      }

      -- Key mappings
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<F5>", dap.continue, opts)
      vim.keymap.set("n", "<F6>", function()
        require("neotest").run.run({ strategy = "dap" })
      end, opts)
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
      vim.keymap.set("n", "<F10>", dap.step_over, opts)
      vim.keymap.set("n", "<F11>", dap.step_into, opts)
      vim.keymap.set("n", "<F8>", dap.step_out, opts)
      vim.keymap.set("n", "<leader>dr", dap.repl.open, opts)
      vim.keymap.set("n", "<leader>dl", dap.run_last, opts)
      vim.keymap.set("n", "<leader>dt", function()
        require("neotest").run.run({ strategy = "dap" })
      end, opts)
    end,
  },

  -- 2️⃣ nvim-dap-ui for debugging UI
  {
    "rcarriga/nvim-dap-ui",
    lazy = false,
    config = function()
      local dapui = require("dapui")
      local dap = require("dap")

      dapui.setup()

      -- Auto open/close dap-ui on debug sessions
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- 3️⃣ Neotest + neotest-dotnet for C# testing
  {
    "nvim-neotest/neotest",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Issafalcon/neotest-dotnet", -- correct plugin
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-dotnet")({
            -- optional: discovery_root = "solution",
            -- optional: dotnet_command = "dotnet",
          }),
        },
      })
    end,
    ft = { "cs", "razor", "csproj" },
  },
}

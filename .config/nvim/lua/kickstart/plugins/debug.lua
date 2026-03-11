-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
local last_executable = nil

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    'Civitasv/cmake-tools.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Core controls
      { '<leader>dd', dap.continue, desc = 'Debug: Start/Continue' },
      { '<leader>dx', dap.terminate, desc = 'Debug: Terminate' },
      { '<leader>dr', dap.restart, desc = 'Debug: Restart' },
      { '<leader>dp', dap.pause, desc = 'Debug: Pause Execution' },
      { '<leader>dc', dap.run_to_cursor, desc = 'Debug: Run to Cursor' },
      { '<leader>dl', dap.run_last, desc = 'Debug: Run Last Session' },

      -- Stepping
      { '<leader>dn', dap.step_over, desc = 'Debug: Step Over (Next)' },
      { '<leader>di', dap.step_into, desc = 'Debug: Step Into' },
      { '<leader>do', dap.step_out, desc = 'Debug: Step Out' },

      -- Breakpoints
      { '<leader>db', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>dB',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },

      -- UI / Info
      { '<leader>du', dapui.toggle, desc = 'Debug: Toggle UI' },
      { '<leader>de', dapui.eval, desc = 'Debug: Evaluate Expresstion' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
      },
    }

    -- System LLDB (NixOS-safe) configuration
    dap.adapters.lldb = {
      type = 'executable',
      command = vim.fn.exepath('lldb-dap'), -- system path from Nix
      name = 'lldb',
    }

    -- local last_executable = nil

    dap.configurations.c = {
      {
        name = 'Launch C program',
        type = 'lldb',
        request = 'launch',
        program = function()
          -- This code runs ONLY when starting the debugger
          local cmake = require('cmake-tools')  -- lazy load here, not at module load

          -- Use cached executable if available
          if last_executable and vim.fn.filereadable(last_executable) == 1 then
            return last_executable
          end

          -- Try CMake launch target
          local target = cmake.get_launch_target_path()
          if target and vim.fn.filereadable(target) == 1 then
            last_executable = target
            return target
          end

          -- Last resort: prompt the user
          local build_dir = vim.fn.getcwd() .. '/build'
          last_executable = vim.fn.input('Path to executable: ', build_dir .. '/', 'file')
          return last_executable
        end,
        -- program = function()
        --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        -- end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
          local cmake = require('cmake-tools')
          return cmake.get_launch_args()
        end,
      },
    }

    -- dap.configurations.cpp = dap.configurations.c

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      -- controls = {
      --   icons = {
      --     pause = '⏸',
      --     play = '▶',
      --     step_into = '⏎',
      --     step_over = '⏭',
      --     step_out = '⏮',
      --     step_back = 'b',
      --     run_last = '▶▶',
      --     terminate = '⏹',
      --     disconnect = '⏏',
      --   },
      -- },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    -- require('dap-go').setup {
    --   delve = {
    --     -- On Windows delve must be run attached or it crashes.
    --     -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    --     detached = vim.fn.has 'win32' == 0,
    --   },
    -- }
  end,
}

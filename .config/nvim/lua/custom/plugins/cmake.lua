return {
  'Civitasv/cmake-tools.nvim',
  module = 'cmake-tools',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    cmake_command = "cmake",
    build_dir = "build",
    cmake_build_directory = "build",
    cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
    cmake_soft_link_compile_commands = true,
  },

  keys = {
    --  -- Open CMake configuration preset picker
    -- { '<leader>cc', '<cmd>CMakeSelectConfigurePreset<cr>', desc = 'CMake: Select Configure Preset' },
    -- Select Command
    --
    { '<leader>cs', group = '[S]elect' },
    { '<leader>cst', '<cmd>CMakeSelectBuildType<cr>', desc = 'CMake: [S]elect Build [T]ype' },
    { '<leader>csb', group = '[B]uild' },
    { '<leader>csbt', '<cmd>CMakeSelectBuildTarget<cr>', desc = 'CMake: [S]elect [B]uild [T]arget' },

    { '<leader>cg', '<cmd>CMakeGenerate<cr>', desc = 'CMake: [G]enerate Make' },
    { '<leader>cb', '<cmd>CMakeBuild<cr>', desc = 'CMake: [B]uild Project' },

    -- Run the current target
    { '<leader>cr', '<cmd>CMakeRun<cr>', desc = 'CMake: [R]un Current Target' },

    { '<leader>cc', '<cmd>CMakeCloseRunner<cr>', desc = 'CMake: [C]lose Runner' },

    -- Clean the build folder
    { '<leader>cl', '<cmd>CMakeClean<cr>', desc = 'CMake: C[l]ean Build' },

    -- Toggle windows
    { '<leader>tr',
      function()
        local found = false
        for _, win in ipairs(vim.api.nvim_list_wins())do
          local buf = vim.api.nvim_win_get_buf(win)
          local name = vim.api.nvim_buf_get_name(buf)
          if name:match("CMakeTools.-Runner") then
            found = true
            break
          end
        end

        if found then
          vim.cmd("CMakeCloseRunner")
        else
          vim.cmd("CMakeOpenRunner")
        end
      end,
      desc = "[T]oggle CMake [R]unner",
    },
    {
      "<leader>te",
      function()
        local found = false
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)

          -- Detect quickfix list
          if vim.bo[buf].buftype == "quickfix" then
            found = true
            break
          end
        end

        if found then
          vim.cmd("CMakeCloseExecutor")
        else
          vim.cmd("CMakeOpenExecutor")
        end
      end,
      desc = "[T]oggle CMake [E]xecutor",
    },
  },
}

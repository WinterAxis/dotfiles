return {
  "danymat/neogen",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("neogen").setup({
      enabled = true,
      languages = {
        c = {
          template = {
            annotation_convention = "doxygen",
          },
        },
        cpp = {
          template = {
            annotation_convention = "doxygen",
          },
        },
      },
    })

    -- Keymap: generate doc comment
    vim.keymap.set("n", "<leader>cd", function()
      require("neogen").generate()
    end, { desc = "Neogen: Generate [D]ocstring" })
  end,
}

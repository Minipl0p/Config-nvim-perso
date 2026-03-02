return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      open_for_directories = false,
      -- Force une UI en float
      floating_window_scaling_factor = 0.9,
      yazi_floating_window_border = "rounded",

      -- Important: ouvre le fichier sélectionné en remplaçant le buffer courant
      open_file_function = function(chosen_file, _)
        -- replace current buffer, no tab/split
        vim.cmd("edit " .. vim.fn.fnameescape(chosen_file))
      end,
    },
    keys = {
      {
        "<C-e>",
        function()
          require("yazi").yazi()
        end,
        desc = "Yazi (float)",
      },
    },
  },
}

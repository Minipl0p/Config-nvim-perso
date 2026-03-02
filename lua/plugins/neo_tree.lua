return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({
            source = "filesystem",
            toggle = true,
            reveal = true,
            position = "float",
          })
        end,
        desc = "Neo-tree (float)",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({
            source = "filesystem",
            focus = true,
            reveal = true,
            position = "float",
          })
        end,
        desc = "Neo-tree focus (float)",
      },
    },
  },
}

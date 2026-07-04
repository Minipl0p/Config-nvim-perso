return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  -- On charge Neo-tree tôt pour pouvoir remplacer l'ouverture d'un dossier au démarrage.
  lazy = false,
  keys = {
    {
      "<leader>e",
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
  opts = {
    -- Plus de fermeture auto liée à "dernière fenêtre" : on n'utilise QUE le float.
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    window = {
      position = "float",
      width = 40,
      mappings = {
        -- l = unfold / open (comme aller à DROITE)
        ["l"] = "open",
        ["<CR>"] = "open",
        ["<S-CR>"] = "open",

        -- <C-CR> = ouvre le fichier PUIS ferme tous les autres buffers.
        ["<C-CR>"] = function(state)
          local node = state.tree:get_node()
          if node.type == "file" then
            require("neo-tree.sources.filesystem.commands").open(state)
            -- Ferme tous les autres buffers (garde celui qu'on vient d'ouvrir).
            vim.schedule(function()
              require("config.buffers").close_others()
            end)
          else
            -- Sur un dossier, <C-CR> se comporte comme open (expand).
            require("neo-tree.sources.filesystem.commands").open(state)
          end
        end,

        -- h = fold / remonte au parent ET le collapse, en un seul coup (comme aller à GAUCHE).
        ["h"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" and node:is_expanded() then
            -- Dossier ouvert -> on le referme (on reste dessus).
            require("neo-tree.sources.filesystem").toggle_directory(state, node)
          else
            -- Fichier ou dossier fermé -> on remonte au parent ET on le collapse.
            local parent_id = node:get_parent_id()
            if parent_id then
              local parent = state.tree:get_node(parent_id)
              require("neo-tree.ui.renderer").focus_node(state, parent_id)
              if parent and parent.type == "directory" and parent:is_expanded() then
                require("neo-tree.sources.filesystem").toggle_directory(state, parent)
              end
            end
          end
        end,

        -- Désactive H/L dans neo-tree pour ne pas masquer la nav buffers globale.
        ["H"] = false,
        ["L"] = false,
      },
    },
    filesystem = {
      -- CLÉ DU FIX : Neo-tree ne hijack plus jamais l'ouverture d'un dossier.
      -- Donc `nvim .` n'ouvre AUCUNE sidebar Neo-tree.
      hijack_netrw_behavior = "disabled",
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    default_component_configs = {
      indent = { with_expanders = true },
    },
  },
}

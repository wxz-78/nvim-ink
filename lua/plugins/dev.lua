-- Plugins extra para programar (además de lo que ya trae LazyVim y los extras de lazyvim.json).
return {
  -- Revisor de diffs y de historial de git, con resolución de conflictos de merge
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview: cambios del repositorio" },
      { "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Diffview: cerrar" },
    },
    opts = { enhanced_diff_hl = true },
  },

  -- Edita el sistema de archivos como si fuera un buffer: renombrar, mover y borrar con dd/p/:w.
  -- «-» abre el directorio del archivo actual. No sustituye al explorador (<leader>e).
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = { { "-", "<cmd>Oil<cr>", desc = "Directorio padre (Oil)" } },
    opts = {
      default_file_explorer = false, -- el explorador de LazyVim sigue abriendo las carpetas
      skip_confirm_for_simple_edits = true,
      view_options = { show_hidden = true },
      keymaps = { ["q"] = "actions.close" },
    },
  },

  -- Separa o une argumentos, tablas y bloques con un atajo (usa Treesitter)
  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = { { "<leader>cj", "<cmd>TSJToggle<cr>", desc = "Separar/unir bloque (treesj)" } },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  -- Detecta si cada archivo usa tabuladores o espacios (y cuántos) al abrirlo
  { "NMAC427/guess-indent.nvim", event = "BufReadPre", opts = {} },
}

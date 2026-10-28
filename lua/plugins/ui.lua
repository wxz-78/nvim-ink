-- Interfaz: mismas formas redondeadas que waybar, mako y fuzzel.
return {
  -- Línea de estado en «píldoras» con el tema Ink (lua/lualine/themes/ink.lua)
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "ink"
      opts.options.component_separators = ""
      opts.options.section_separators = { left = vim.fn.nr2char(0xe0b4), right = vim.fn.nr2char(0xe0b6) }
    end,
  },

  { "akinsho/bufferline.nvim", opts = { options = { separator_style = "thin" } } },

  { "folke/which-key.nvim", opts = { win = { border = "rounded" } } },

  -- Pantalla de inicio
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
██╗███╗   ██╗██╗  ██╗
██║████╗  ██║██║ ██╔╝
██║██╔██╗ ██║█████╔╝
██║██║╚██╗██║██╔═██╗
██║██║ ╚████║██║  ██╗
╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝]],
        },
      },
    },
  },
}

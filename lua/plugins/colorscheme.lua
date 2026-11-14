-- Tema Ink: los grises de tu dotfile (colors/ink.lua y lua/ink/).
return {
  -- LazyVim trae tokyonight y catppuccin; aquí no se usan, así que no se descargan
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },

  { "LazyVim/LazyVim", opts = { colorscheme = "ink" } },
}

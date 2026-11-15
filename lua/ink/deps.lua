-- Herramientas externas que LazyVim y Mason necesitan.
-- Única fuente de verdad: la usan el aviso de arranque (config/autocmds.lua),
-- `:checkhealth ink` y, por nombre de binario, install.sh (check.sh las compara).
local M = {}

M.tools = {
  { "git", "necesario para lazy.nvim y LazyVim" },
  { "rg", "búsqueda en el proyecto" },
  { "fd", "búsqueda de archivos" },
  { "gcc", "compilador para nvim-treesitter" },
  { "node", "Mason y varios servidores LSP" },
  { "npm", "Mason y varios servidores LSP" },
  { "tree-sitter", "CLI para nvim-treesitter" },
  { "lazygit", "interfaz de Git (<leader>gg)" },
}

--- Devuelve la lista de { binario, motivo } que no están en el PATH.
function M.missing()
  local missing = {}
  for _, tool in ipairs(M.tools) do
    if vim.fn.executable(tool[1]) == 0 then
      table.insert(missing, tool)
    end
  end
  return missing
end

return M

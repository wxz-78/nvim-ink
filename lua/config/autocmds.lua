-- Modificado a partir de LazyVim/starter (Apache-2.0). Ver NOTICE.
-- Autocmds que se cargan en el evento VeryLazy.
-- Los de fábrica: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Quita los espacios al final de línea al guardar (menos ruido en los diffs).
-- Se salta Markdown (dos espacios = salto de línea), el correo con formato flowed,
-- los diffs y cualquier buffer especial o de solo lectura.
-- Para desactivarlo en un buffer concreto: :lua vim.b.ink_no_trim = true
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("ink_trim_whitespace", { clear = true }),
  desc = "Ink: eliminar espacios al final de línea al guardar",
  callback = function(event)
    local buf = event.buf
    local bo = vim.bo[buf]

    if vim.b[buf].ink_no_trim or not bo.modifiable or bo.readonly or bo.buftype ~= "" or bo.binary then
      return
    end

    local ft = bo.filetype
    if
      ft:match("^markdown")
      or ft == "mail"
      or ft == "diff"
      or ft == "gitsendemail"
      or ft == "oil"
      or ft == "vimwiki"
    then
      return
    end

    local current = vim.api.nvim_get_current_buf() == buf
    local view = current and vim.fn.winsaveview() or nil
    -- nvim_buf_call hace que `%s` actúe sobre el buffer que se guarda y no
    -- sobre el buffer visible (importante al usar :wall o al guardar en segundo plano).
    -- silent! evita el mensaje «N substitutions…» y keepjumps no ensucia la lista de saltos.
    vim.api.nvim_buf_call(buf, function()
      vim.cmd([[silent! keepjumps keeppatterns %s/\s\+$//e]])
    end)
    if view then
      vim.fn.winrestview(view)
    end
  end,
})

-- Cierra con q las ventanas que no son de edición (ayuda, quickfix, man, health...).
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ink_close_windows", { clear = true }),
  desc = "Ink: cerrar ventanas de solo lectura con q",
  pattern = { "checkhealth", "help", "lspinfo", "man", "qf" },
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, desc = "Cerrar ventana" })
    vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = event.buf, desc = "Cerrar ventana" })
  end,
})

-- Aviso único si falta alguna herramienta externa que LazyVim y Mason necesitan.
-- Sin npm, por ejemplo, Mason no puede instalar vtsls, pyright, jsonls, yamlls ni dockerls
-- y salen muchos «failed to install» seguidos. La lista vive en lua/ink/deps.lua.
-- Se salta en modo headless (CI, scripts) y con vim.g.ink_skip_deps_check = true.
vim.schedule(function()
  if vim.g.ink_skip_deps_check or #vim.api.nvim_list_uis() == 0 then
    return
  end

  local names = {}
  for _, tool in ipairs(require("ink.deps").missing()) do
    table.insert(names, tool[1])
  end
  if #names > 0 then
    vim.notify(
      "Ink: faltan herramientas en el PATH: " .. table.concat(names, ", ") .. "\nVer :checkhealth ink y el README.",
      vim.log.levels.WARN
    )
  end
end)

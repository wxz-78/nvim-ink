-- Modificado a partir de LazyVim/starter (Apache-2.0). Ver NOTICE.
-- Autocmds que se cargan en el evento VeryLazy.
-- Los de fábrica: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Quita los espacios al final de línea al guardar (menos ruido en los diffs).
-- Se salta Markdown (dos espacios = salto de línea), el correo con formato flowed,
-- los diffs y cualquier buffer especial o de solo lectura.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("ink_trim_whitespace", { clear = true }),
  desc = "Ink: eliminar espacios al final de línea al guardar",
  callback = function(event)
    local buf = event.buf
    local bo = vim.bo[buf]

    if not bo.modifiable or bo.buftype ~= "" or bo.binary then
      return
    end

    local ft = bo.filetype
    if ft:match("^markdown") or ft == "mail" or ft == "diff" or ft == "gitsendemail" or ft == "oil" then
      return
    end

    local view = vim.fn.winsaveview()
    -- nvim_buf_call hace que `%s` actúe sobre el buffer que se guarda y no
    -- sobre el buffer visible (importante al usar :wall o al guardar en segundo plano).
    vim.api.nvim_buf_call(buf, function()
      vim.cmd([[keeppatterns %s/\s\+$//e]])
    end)
    vim.fn.winrestview(view)
  end,
})

-- Aviso único si falta alguna herramienta externa que LazyVim y Mason necesitan.
-- Sin npm, por ejemplo, Mason no puede instalar vtsls, pyright, jsonls, yamlls ni dockerls
-- y salen muchos «failed to install» seguidos.
vim.schedule(function()
  local missing = {}
  for _, bin in ipairs({ "git", "rg", "fd", "gcc", "npm", "tree-sitter", "lazygit" }) do
    if vim.fn.executable(bin) == 0 then
      table.insert(missing, bin)
    end
  end
  if #missing > 0 then
    vim.notify(
      "Ink: faltan herramientas en el PATH: " .. table.concat(missing, ", ") .. "\nVer «Instalación» en el README.",
      vim.log.levels.WARN
    )
  end
end)

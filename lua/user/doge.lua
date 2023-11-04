local status_ok, doge = pcall(require, "doge")
if not status_ok then
  return
end

vim.g.doge_doc_standard_python = 'google'

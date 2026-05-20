local M = {}

local function git(args)
  local out = vim.fn.systemlist(args)
  return vim.v.shell_error == 0 and out or nil
end

function M.git_root()
  local out = git { 'git', 'rev-parse', '--show-toplevel' }
  return out and out[1] or nil
end

function M.default_branch()
  local out = git { 'git', 'symbolic-ref', '--short', 'refs/remotes/origin/HEAD' }
  if out and out[1] then return (out[1]:gsub('^origin/', '')) end
  for _, b in ipairs { 'main', 'master' } do
    if git { 'git', 'rev-parse', '--verify', '--quiet', b } then return b end
  end
  return nil
end

function M.current_branch()
  local out = git { 'git', 'rev-parse', '--abbrev-ref', 'HEAD' }
  return out and out[1] or nil
end

function M.is_clean()
  local out = git { 'git', 'status', '--porcelain' }
  return out ~= nil and #out == 0
end

-- Returns { action = 'dirty' | 'on_default' | 'diff_against', branch = ?  }
function M.resolve()
  if not M.is_clean() then return { action = 'dirty' } end
  local def = M.default_branch()
  if not def then return { action = 'dirty' } end
  if M.current_branch() == def then return { action = 'on_default', branch = def } end
  return { action = 'diff_against', branch = def }
end

return M

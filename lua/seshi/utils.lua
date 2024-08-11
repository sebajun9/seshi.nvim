local M = {}

function M.create_save_dir(save_dir)
  local stat = vim.uv.fs_stat(save_dir)
  if not stat then
    local success, _ = pcall(function()
      vim.fn.mkdir(save_dir, 'p')
    end)
    return success
  end
  return true
end

function M.get_current_session_save_filepath(save_dir)
  local cwd = M.encode_path(vim.uv.cwd())
  local branch_name = M.encode_path(M.get_git_branch())
  local current_session_name = cwd .. '@@'
  if branch_name ~= '' then
    current_session_name = current_session_name .. branch_name
  end
  return save_dir .. current_session_name
end

function M.split_session_filename(session_filepath)
  local parts = {}
  for part in string.gmatch(session_filepath, '([^@@]+)') do
    table.insert(parts, part)
  end
  return parts[1], parts[2]
end

function M.get_git_branch()
  local git_branch = vim.fn.systemlist('git branch --show-current')
  if git_branch[1]:match('^fatal:') then
    return ''
  end
  return git_branch[1]
end

function M.encode_path(path)
  return path:gsub('([^A-Za-z0-9])', function(c)
    return string.format('%%%02X', string.byte(c))
  end)
end

function M.decode_path(encoded_path)
  return encoded_path:gsub('%%(%x%x)', function(hex)
    return string.char(tonumber(hex, 16))
  end)
end

return M
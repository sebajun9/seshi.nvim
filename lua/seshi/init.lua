local utils = require('seshi.utils')
local config = require('seshi.config')
local M = {}

function M.current_session_exists()
  local session_save_filepath = utils.get_current_session_save_filepath(M.options.save_dir)
  if vim.uv.fs_stat(session_save_filepath) then
    return true
  end
  return false
end

function M.delete_session(session_filepath)
  local session_filename = vim.fs.basename(session_filepath)
  if
    vim.fn.confirm('Delete session file: ' .. utils.decode_path(session_filename), '&Yes\n&No') == 1
  then
    vim.fn.delete(session_filepath)
  end
end

function M.delete_current_session()
  local session_save_filepath = utils.get_current_session_save_filepath(M.options.save_dir)
  M.delete_session(session_save_filepath)
end

function M.load_session(session_filepath)
  if not vim.uv.fs_stat(session_filepath) then
    vim.api.nvim_err_writeln('Seshi: File not found: ' .. session_filepath)
    return
  end

  vim.api.nvim_exec_autocmds('User', { pattern = 'SeshiLoadPre' })

  local session_filename = vim.fs.basename(session_filepath)
  local session_path, branch_name = utils.split_session_filename(session_filename)
  session_path = utils.decode_path(session_path)
  branch_name = utils.decode_path(branch_name)
  local git_switch = vim.fn.system('git -C ' .. session_path .. ' switch ' .. branch_name)
  if git_switch:match('error: ') then
    vim.api.nvim_err_writeln(git_switch)
    vim.api.nvim_err_writeln('seshi.nvim: Failed to switch branch. Abort loading session.')
    return
  end
  vim.fn.chdir(session_path)
  local session_filepath_escaped = vim.fn.fnameescape(session_filepath)
  vim.cmd('silent source ' .. session_filepath_escaped)

  vim.api.nvim_exec_autocmds('User', { pattern = 'SeshiLoadPost' })
end

function M.load_current_directory_session()
  local session_save_filepath =
    utils.get_current_session_save_filepath(M.options.save_dir, M.options.use_git_root)
  if not vim.uv.fs_stat(session_save_filepath) then
    if not M.options.silent then
      print('Seshi: Could not find session file: ' .. session_save_filepath)
    end
    return
  end

  vim.api.nvim_exec_autocmds('User', { pattern = 'SeshiLoadPre' })

  vim.cmd('source ' .. vim.fn.fnameescape(session_save_filepath))

  vim.api.nvim_exec_autocmds('User', { pattern = 'SeshiLoadPost' })
end

function M.save_session()
  vim.api.nvim_exec_autocmds('User', { pattern = 'SeshiSavePre' })

  local session_save_filepath =
    utils.get_current_session_save_filepath(M.options.save_dir, M.options.use_git_root)
  vim.cmd('mks! ' .. vim.fn.fnameescape(session_save_filepath))

  vim.api.nvim_exec_autocmds('User', { pattern = 'SeshiSavePost' })
end

function M.setup(opts)
  opts = opts or {}
  M.options = vim.tbl_deep_extend('force', {}, config.defaults())
  M.options = vim.tbl_deep_extend('force', M.options, opts)

  if not utils.create_save_dir(M.options.save_dir) then
    print('Seshi: Failed to create save directory.')
    return
  end

  if M.options.autoload and vim.fn.argc() == 0 then
    if not M.options.silent then
      print('Seshi: Trying autoload session...')
    end
    M.load_current_directory_session()
  end
end

return M

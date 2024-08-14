local M = {}

function M.defaults()
  local defaults = {
    save_dir = vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/'),
    autoload = true,
    use_git_root = true,
    silent = true,
    telescope = {
      mappings = {
        delete_session = '<C-d>',
      },
    },
  }
  return defaults
end

return M

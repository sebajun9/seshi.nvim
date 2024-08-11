local M = {}

function M.defaults()
  local defaults = {
    save_dir = vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/'),
    autoload = true,
    silent = false,
    telescope = {
      mappings = {
        delete_session = '<C-d>',
      },
    },
  }
  return defaults
end

return M

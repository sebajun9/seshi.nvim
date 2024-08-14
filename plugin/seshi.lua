local seshi = require('seshi')

vim.api.nvim_create_user_command('SeshiSave', function()
  seshi.save_session()
end, {})

vim.api.nvim_create_user_command('SeshiLoadCurrent', function()
  seshi.load_current_directory_session()
end, {})

vim.api.nvim_create_user_command('SeshiDeleteCurrent', function()
  seshi.delete_current_session()
end, {})

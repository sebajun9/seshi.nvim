local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local seshi = require('seshi')
local utils = require('seshi.utils')

local function list_sessions()
  local sessions = {}
  local save_dir = seshi.options.save_dir
  local files = vim.fn.glob(save_dir .. '*', false, true)

  for _, file in ipairs(files) do
    local session_name = vim.fn.fnamemodify(file, ':t')
    local dir_path, branch = utils.split_session_filename(session_name)
    -- Decode the path and branch
    dir_path = utils.decode_path(dir_path)
    branch = branch and utils.decode_path(branch) or nil

    table.insert(sessions, {
      name = session_name,
      file_path = file,
      dir_path = dir_path,
      branch = branch,
    })
  end

  return sessions
end

local function search_sessions(opts)
  opts = opts or {}

  pickers
    .new(opts, {
      prompt_title = 'Sessions',
      finder = finders.new_table({
        results = list_sessions(),
        entry_maker = function(entry)
          local display = entry.dir_path
          if entry.branch then
            display = display .. ' (' .. entry.branch .. ')'
          end
          return {
            value = entry,
            display = display,
            ordinal = entry.name,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          seshi.load_session(selection.value.file_path)
        end)

        map('i', seshi.options.telescope.mappings.delete_session, function()
          local selection = action_state.get_selected_entry()
          if selection then
            local file_path = selection.value.file_path
            seshi.delete_session(file_path)
          end
        end)
        return true
      end,
    })
    :find()
end
return require('telescope').register_extension({
  exports = {
    seshi = search_sessions,
  },
  setup = function(ext_config, config)
    vim.api.nvim_create_user_command('SeshiList', function()
      search_sessions()
    end, {})
  end,
})

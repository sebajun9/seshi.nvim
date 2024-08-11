# seshi.nvim

Seshi.nvim is a Git-aware session manager for Neovim with Telescope integration.

# Features

1. Git-aware Session Management
- Creates and manages sessions based on the current Git branch
- Automatically switches working directory and Git branch when loading a session

2. Telescope Integration
- Quick session switching using Telescope
- Delete sessions using Telescope

3. Autoload Functionality
- Option to automatically load a session based on the current working directory
and active Git branch

4. Event Hooks
- Trigger events before and after loading/saving sessions.
- `SeshiLoadPre`
- `SeshiLoadPost`
- `SeshiSavePre`
- `SeshiSavePost`

# Installation
[Lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
-- Lua
{
    "sebajun9/seshi.nvim",
    lazy = false, -- Required only if autoloading.
    opt = {}
}

```
# Configuration

## Defaults
```lua
-- Lua
{
    "sebajun9/seshi.nvim",
    lazy = false, -- Required only if autoloading.
    opt = {
        save_dir = vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/'),
        autoload = true,
        silent = false,
        telescope = {
          mappings = {
            delete_session = '<C-d>',
          },
        },
      }
    }
}

```

## save_dir
Session files will be saved to and loaded from `save_dir`.

## autoload
If `autoload` is set to `true`, upon loading `nvim` without any arguments, will
attempt to load an existing session file for the current working directory and
Git branch.

## silent
If `silent` is set to `true`, it will suppress print statements out of seshi.nvim.

## telescope
### mappings
#### delete-session
Key map for deleting a session file while inside of Telescope.

# Scenarios
## First time running in a project
1. Start Neovim in your project
2. Open your buffers and windows
3. Run `:SeshiSave`
4. Your buffers and windows are now saved for the current directory and branch.

## Resuming from outside a project directory
1. Start Neovim
2. Run `:SeshiList` to bring up a Telescope picker with available sessions
3. Select the session you want
4. Start coding!

## Resuming from inside a project directory
1. Start Neovim
2. seshi.nvim will try to load a session file for the current project and branch.
3. Start coding!

# Usage
## SeshiSave


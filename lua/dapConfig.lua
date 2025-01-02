local dap = require('dap')
local dapui = require('dapui')
local virt = require("nvim-dap-virtual-text")
local vscode = require('dap.ext.vscode')

dap.adapters.cpp = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode-14', -- must be absolute
  name = 'lldb',
}

dap.configurations.cpp = {
  {
    type = 'cpp',
    request = 'launch',
    name = 'LLDB',
    -- TODO this is silly
    program = '/home/besch/git/algo/hippo/out/cascadelake/dbg/test/run_tests',
  },
  {
    type = 'cpp',
    request = 'attach',
  }
}

dap.adapters.python = {
  type = 'executable',
  command = 'python3',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    name = 'run-py',
    type = 'python',
    request = 'launch',
    program = '${file}',
    args = {},
    -- choices are "internalConsole", "integratedTerminal" and "externalTerminal"
    --console = "integratedTerminal",
    console = "internalConsole",
    -- cwd = "",
  }
}

local function open_launch_json()
  -- Just check local directory
  local filename = 'launch.json'
  local fd = vim.loop.fs_open(filename, "r", 438)
  if fd == nil then
    return nil
  end

  assert(vim.loop.fs_close(fd))
  vscode.load_launchjs(filename, {})
end

-- BAE TODO maybe I should create an autocommand to re-load on a bufwrite
open_launch_json()
vim.api.nvim_create_user_command('DapLoadLaunchJson', open_launch_json, {})

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🚩', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '⇒', texthl = '', linehl = '', numhl = '' })

local opts = { silent = true }
vim.keymap.set("n", "<F8>", dap.step_over, opts)
vim.keymap.set("n", "<F7>", dap.step_into, opts)
vim.keymap.set("n", "<S-F8>", dap.step_out, opts)
vim.keymap.set("n", "<F9>", dap.continue, opts)
-- Second continue keybinding
vim.keymap.set("n", "<leader>dc", dap.continue, opts)
vim.keymap.set("n", "<S-F9>", dap.run_to_cursor, opts)
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, opts)
vim.keymap.set("n", "<leader>dr", dap.restart, opts)

dapui.setup({
  layouts = {{
    elements = {
      { id = "breakpoints", size = 0.33 },
      { id = "stacks", size = 0.33 },
      { id = "watches", size = 0.33 },
    },
    position = "left",
    size = 40
  }, {
    elements = {
      { id = "scopes", size = 0.5 },
      { id = "repl", size = 0.5 },
      --{ id = "console", size = 0.5 }
    },
    position = "bottom",
    size = 20
  }},
  mappings = {
    edit = "e",
    expand = { "h", "l" },
    open = { "<CR>", "o" },
    remove = "d",
    repl = "r",
    toggle = "t"
  },
})
virt.setup()

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

--vim.api.nvim_create_user_command('Dap', open_launch_json, {})

local dap = require('dap')
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

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl='', linehl ='', numhl = ''})
vim.fn.sign_define('DapStopped', { text = '🟢', texthl='', linehl ='', numhl = ''})

local opts = { silent = true }
vim.keymap.set("n", "<leader>dj", dap.step_over, opts)
vim.keymap.set("n", "<leader>dl", dap.step_into, opts)
vim.keymap.set("n", "<leader>dh", dap.step_out, opts)
vim.keymap.set("n", "<leader>dc", dap.continue, opts)
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, opts)
vim.keymap.set("n", "<leader>dr", dap.repl.open, opts)

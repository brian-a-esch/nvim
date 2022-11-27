-- This code has "special projects" which have different default
-- spacing than normal. The variation in C++ project formatting is
-- large so its hard to define the right "default" for everything
-- like we can for python or golang
local home = os.getenv('HOME')
local four_space_projects = {
  home .. '/test',
}
local filename = vim.api.nvim_buf_get_name(0)

local is_four_space = false
for _, project_dir in ipairs(four_space_projects) do
  if string.find(filename, project_dir) then
    is_four_space = true
  end
end

-- Use 81 since we want to limit to 80 chars
vim.o.colorcolumn = "81"

if is_four_space then
  vim.o.tabstop = 4
  vim.o.shiftwidth = 4
else
  vim.o.tabstop = 2
  vim.o.shiftwidth = 2
end

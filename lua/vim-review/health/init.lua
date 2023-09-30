local M = {}

local health = vim.health

M.check = function()
  health.start("vim-review report")

  if vim.fn.exists(':Gvdiffsplit') == 2 then
    health.ok('vim-fugitive plugin installed')
  else
    health.error('vim-fugitive plugin not found, make sure to install it')
  end
end

return M

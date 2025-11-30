local M = {}
local HotReload = require("omarchy-themer.hot-reload")

M.opts = {
  theme_changed = function ()
  end,

  theme_module = nil,
}

function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  HotReload.listen(M.opts)
end

return M

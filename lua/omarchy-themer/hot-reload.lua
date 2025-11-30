local M = {}

function M.listen(opts)
  vim.api.nvim_create_autocmd("User", {
	  pattern = "LazyReload",
	  callback = function()
		  -- Unload the theme module
			package.loaded[opts.theme_module] = nil

			vim.schedule(function()
				local ok, theme_spec = pcall(require, opts.theme_module)
				if not ok then
					return
				end

				-- Clear all highlight groups before applying new theme
				vim.cmd("highlight clear")
				if vim.fn.exists("syntax_on") then
					vim.cmd("syntax reset")
				end

				-- Reset background to default so colorscheme can set it properly (light themes will set to light)
				vim.o.background = "dark"

				for _, spec in ipairs(theme_spec) do
					if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
						local colorscheme = spec.opts.colorscheme

            -- Load the colorscheme plugin and install it if missing
            require("lazy.core.loader").colorscheme(colorscheme)
            require("lazy.core.loader").install_missing()

            -- Apply the colorscheme (it will set background itself)
            pcall(vim.cmd.colorscheme, colorscheme)
            vim.cmd("redraw!")

            opts.theme_changed()

            -- Flush
            vim.cmd("redraw!")

            break
          end
        end
      end)
    end
  })
end

return M;

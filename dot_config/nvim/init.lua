-- disable some built_in plugins --
local disabled_built_ins = {
	"gzip",
	"man",
	"shada_plugin",
	"tarPlugin",
	"tar",
	"zipPlugin",
	"zip",
	-- 'netrwPlugin',
	"tutor_mode_plugin",
	"remote_plugins",
	"spellfile_plugin",
	"2html_plugin",
}

for _, i in pairs(disabled_built_ins) do
	vim.g["loaded_" .. i] = 1
end

--------------------------
--       Utilities      --
--------------------------

local display_venv = function()
	local venv = vim.env.VIRTUAL_ENV
	if venv then
		return venv
	else
		return ""
	end
end

-- require("lsp")

-- require("keymappings")

--------------------------
--  Bootstrap lazy.nvim --
--------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

------------------------
--  General Settings  --
------------------------

local default_options = { -- create table of options
	-- clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 2, -- more space in the neovim command line for displaying messages
	fileencoding = "utf-8", -- use utf-8 file encoding
	fileformat = "unix", -- force unix file format
	foldmethod = "marker", -- code folding, set to "expr" for treesitter based folding
	foldexpr = "", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
	hlsearch = true, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case when searching, see also: smartcase
	smartcase = true, -- case sensitive search if at least one letter is uppercase
	mouse = "a", -- enable mouse for nvim
	showmode = false, -- don't show which mode we are in
	-- pumheight = 10,  -- popup menu height
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	termguicolors = true, -- set term gui colors
	title = true, -- set the title of window to the value of the titlestring
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
	cursorline = true, -- highlight the current line
	cursorlineopt = "number", -- Comma-separated list of settings for how 'cursorline' is displayed.
	number = true, -- set numbered lines
	relativenumber = true, -- set relative numbered lines
	numberwidth = 2, -- set number column width
	signcolumn = "auto:1-2", -- always show the sign column, otherwise it would shift text each time
	spell = false, -- disable spell checking
	-- spelllang = "en",  -- spell checking language
	scrolloff = 8, -- Minimal number of lines to keep above and below the cursor
	sidescrolloff = 8, -- same as above, except for left and right, if nowrap is set
	-- timeoutlen = 100, -- time to wait for a mapped sequence to complete (in milliseconds)
	undodir = os.getenv("HOME") .. "/.vim/undo/", -- set an undo directory
	undofile = true, -- enable persistent undo
	updatetime = 300, -- faster completion
	wrap = true, -- display lines as one long line
	autoread = true, -- Detect changes in files if they are edited outside of nvim
	wildmenu = true, -- Shows possible matches when using tab completion
	-- showtabline = 2,  -- always show tabs
	hidden = true, -- any buffer can be hidden (keeping its changes)
	path = "**", -- set 'path' to current directory and recursive subdirectories of the current directory
}

-- assign all options in default_options
for k, v in pairs(default_options) do
	vim.opt[k] = v
end

-- completion global settings
vim.o.completeopt = "menu,menuone,noselect"

-- Set borders for all floating windows
vim.o.winborder = "rounded"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			"Mofiqul/dracula.nvim",
			lazy = false, -- make sure we load this during startup if it is your main colorscheme
			priority = 1000, -- make sure to load this before all the other start plugins
			opts = function()
				-- load the colorscheme here
				vim.cmd([[colorscheme dracula]])
			end,
		},
		{
			"numToStr/Comment.nvim",
			opts = function()
				require("Comment").setup()
			end,
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = function()
				require("ibl").setup()
			end,
		},
		{
			"norcalli/nvim-colorizer.lua",
		},
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			-- build = "make install_jsregexp"
		},
		{ "neovim/nvim-lspconfig" },
		{
			"hrsh7th/cmp-nvim-lsp",
		},
		{
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		{
			"hrsh7th/cmp-buffer",
		},
		{
			"hrsh7th/cmp-path",
		},
		{
			"hrsh7th/cmp-cmdline",
		},
		{ "saadparwaiz1/cmp_luasnip" },
		{
			"hrsh7th/nvim-cmp",
			opts = function()
				-- Setup nvim-cmp.
				local cmp = require("cmp")
				local luasnip = require("luasnip")

				cmp.setup({
					view = {
						entries = { name = "custom", selection_order = "near_cursor" },
					},
					formatting = {
						format = function(entry, vim_item)
							-- Source
							vim_item.menu = ({
								buffer = "[Buffer]",
								nvim_lsp = "[LSP]",
								nvim_lsp_signature_help = "[SignatureHelp]",
								luasnip = "[LuaSnip]",
								path = "[Path]",
							})[entry.source.name]
							return vim_item
						end,
					},
					snippet = {
						-- REQUIRED - you must specify a snippet engine
						expand = function(args)
							-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
							require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
							-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
							-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
						end,
					},
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered({ border = "single" }),
					},
					mapping = cmp.mapping.preset.insert({
						["<C-u>"] = cmp.mapping.scroll_docs(-4),
						["<C-d>"] = cmp.mapping.scroll_docs(4),
						["<C-x>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
						-- ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								if luasnip.expandable() then
									luasnip.expand()
								else
									cmp.confirm({
										select = true,
									})
								end
							else
								fallback()
							end
						end),

						["<C-n>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.locally_jumpable(1) then
								luasnip.jump(1)
							else
								fallback()
							end
						end, { "i", "s" }),

						["<C-p>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.locally_jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
					}),

					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "nvim_lsp_signature_help" },
						-- { name = 'vsnip' }, -- For vsnip users.
						{ name = "luasnip" }, -- For luasnip users.
						-- { name = 'ultisnips' }, -- For ultisnips users.
						-- { name = 'snippy' }, -- For snippy users.
					}, {
						{ name = "buffer" },
						{ name = "path" },
					}),
				})

				-- Set configuration for specific filetype.
				-- cmp.setup.filetype('gitcommit', {
				--   sources = cmp.config.sources({
				--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
				--   }, {
				--     { name = 'buffer' },
				--   })
				-- })

				-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
				-- cmp.setup.cmdline('/', {
				--   mapping = cmp.mapping.preset.cmdline(),
				--   sources = {
				--     { name = 'buffer' }
				--   }
				-- })

				-- cmp.setup.cmdline(":", {
				-- 	formatting = {
				-- 		format = function(entry, vim_item)
				-- 			-- Source
				-- 			vim_item.kind = nil
				-- 			vim_item.menu = ({
				-- 				path = "[Path]",
				-- 			})[entry.source.name]
				-- 			return vim_item
				-- 		end,
				-- 	},
				-- 	mapping = cmp.mapping.preset.cmdline(),
				-- 	sources = cmp.config.sources({
				-- 		{ name = "path" },
				-- 	}, {
				-- 		{ name = "cmdline" },
				-- 	}),
				-- })
				cmp.setup.cmdline(":", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = "path" },
					}, {
						{ name = "cmdline" },
					}),
					matching = { disallow_symbol_nonprefix_matching = false },
				})
			end,
		},
		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					-- Customize or remove this keymap to your liking
					"<leader>ft",
					function()
						require("conform").format({ async = true })
					end,
					mode = "",
					desc = "Format buffer",
				},
			},
			-- This will provide type hinting with LuaLS
			---@module "conform"
			---@type conform.setupOpts
			opts = {
				-- Define your formatters
				formatters_by_ft = {
					lua = { "stylua" },
					j2 = { "djlint" },
					python = {
						-- To fix auto-fixable lint errors.
						"ruff_fix",
						-- To run the Ruff formatter.
						"ruff_format",
						-- To organize the imports.
						"ruff_organize_imports",
					},
					-- javascript = { "prettierd", "prettier", stop_after_first = true },
				},
				-- Set default options
				default_format_opts = {
					lsp_format = "fallback",
				},
				-- Set up format-on-save
				format_on_save = { timeout_ms = 500 },
				-- Customize formatters
				formatters = {
					-- shfmt = {
					--   prepend_args = { "-i", "2" },
					-- },
				},
			},
			init = function()
				-- If you want the formatexpr, here is the place to set it
				vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			end,
		},
		{
			"windwp/nvim-autopairs",
			opts = function()
				require("nvim-autopairs").setup({
					check_ts = true,
					ts_config = {
						lua = { "string" }, -- it will not add pair on that treesitter node
						javascript = { "template_string" },
						java = false, -- don't check treesitter on java
					},
				})
			end,
		},
		{
			"nvim-lua/plenary.nvim",
			lazy = true,
		},
		{
			"nvim-telescope/telescope.nvim",
			branch = "0.1.x",
			opts = function()
				local actions = require("telescope.actions")
				require("telescope").setup({

					defaults = {
						-- Default configuration for telescope goes here:
						-- config_key = value,
						vimgrep_arguments = {
							"rg",
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
							"--smart-case",
							"--trim", -- add this value
						},
						file_ignore_patterns = {
							"Applications",
							"Calibre% Library",
							"Music",
							"Pictures",
							"Videos",
							"__pycache__",
							".*%.pdf",
							"%.venv",
							"%.mypy_cache",
							"%.pytest_cache",
							"scoop",
							"dist",
						},

						mappings = {
							-- default mappings list: https://github.com/nvim-telescope/telescope.nvim#default-mappings
							i = {
								["<Esc>"] = actions.close,
								["<C-s>"] = actions.select_horizontal,
							},
						},
					},
					pickers = {
						-- Default configuration for builtin pickers goes here:
						-- picker_name = {
						--   picker_config_key = value,
						--   ...
						-- }
						find_files = {
							hidden = true,
							no_ignore = true,
							no_ignore_parent = true,
							find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
						},
						-- Now the picker_config_key will be applied every time you call this
						-- builtin picker
					},
					extensions = {
						-- Your extension configuration goes here:
						-- extension_name = {
						--   extension_config_key = value,
						-- }
						-- please take a look at the readme of the extension you want to configure
					},
				})
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			opts = function()
				local configs = require("nvim-treesitter.configs")
				configs.setup({
					autotag = {
						enable = true,
						filetypes = { "html", "htmldjango", "xml" },
					},
					ensure_installed = {
						"bash",
						"comment",
						"css",
						"dockerfile",
						"git_config",
						"gitcommit",
						"gitignore",
						"go",
						"gomod",
						"gosum",
						"gowork",
						"html",
						"http",
						"javascript",
						"jinja",
						"jinja_inline",
						"jq",
						"json",
						"lua",
						"markdown",
						"markdown_inline",
						"python",
						"regex",
						"toml",
						"xml",
						"yaml",
					},
					highlight = {
						enable = true,
					},
					endwise = {
						enable = true,
					},
				})
			end,
		},
		{
			"windwp/nvim-ts-autotag",
		},
		{
			"RRethy/nvim-treesitter-endwise",
		},
		-- {
		--   'alker0/chezmoi.vim',
		--   lazy = false,
		--   init = function()
		--     -- This option is required.
		--     vim.g['chezmoi#use_tmp_buffer'] = true
		--     -- add other options here if needed.
		--   end,
		--   },
		{
			"folke/trouble.nvim",
			opts = {}, -- for default options, refer to the configuration section for custom setup.
			cmd = "Trouble",
			keys = {
				{
					"<leader>xx",
					"<cmd>Trouble diagnostics toggle<cr>",
					desc = "Diagnostics (Trouble)",
				},
				{
					"<leader>xX",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					desc = "Buffer Diagnostics (Trouble)",
				},
				{
					"<leader>cs",
					"<cmd>Trouble symbols toggle focus=false<cr>",
					desc = "Symbols (Trouble)",
				},
				{
					"<leader>cl",
					"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
					desc = "LSP Definitions / references / ... (Trouble)",
				},
				{
					"<leader>xL",
					"<cmd>Trouble loclist toggle<cr>",
					desc = "Location List (Trouble)",
				},
				{
					"<leader>xQ",
					"<cmd>Trouble qflist toggle<cr>",
					desc = "Quickfix List (Trouble)",
				},
			},
		},
		{
			"hoob3rt/lualine.nvim",
			config = function()
				local trouble = require("trouble")
				local symbols = trouble.statusline({
					mode = "lsp_document_symbols",
					groups = {},
					title = false,
					filter = { range = true },
					format = "{kind_icon}{symbol.name:Normal}",
					-- The following line is needed to fix the background color
					-- Set it to the lualine section you want to use
					hl_group = "lualine_c_normal",
				})
				require("lualine").setup({
					options = {
						icons_enabled = true,
						globalstatus = true,
						theme = "auto",
						component_separators = { left = "|", right = "|" },
						section_separators = { left = "", right = "" },
						disabled_filetypes = { "netrw" },
						always_divide_middle = true,
					},
					sections = {
						lualine_a = { "mode" },
						lualine_b = { "branch" },
						lualine_c = { display_venv },
						lualine_x = {
							{ symbols.get, cond = symbols.has },
							{
								"lsp_status",
								icon = "", -- f013
								symbols = {
									-- Standard unicode symbols to cycle through for LSP progress:
									spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
									-- Standard unicode symbol for when LSP is done:
									done = "✓",
									-- Delimiter inserted between LSP names:
									separator = ",",
								},
								-- List of LSP names to ignore (e.g., `null-ls`):
								ignore_lsp = {},
								-- Display the LSP name
								show_name = true,
							},
							"encoding",
							{
								"fileformat",
								symbols = {
									unix = "unix",
									dos = "dos",
									mac = "mac",
								},
							},
							"filetype",
						},
						lualine_y = { "progress" },
						lualine_z = { "location" },
					},
					inactive_sections = {
						-- lualine_a = {},
						-- lualine_b = {'diff'},
						-- lualine_c = {'filename'},
						-- lualine_x = {'location'},
						-- lualine_y = {},
						-- lualine_z = {}
					},
					tabline = {
						lualine_a = {
							{
								"tabs",
								max_length = vim.o.columns / 3, -- maximum width of tabs component.
								-- note:
								-- it can also be a function that returns
								-- the value of `max_length` dynamically.
								mode = 2, -- 0: shows tab_nr
								-- 1: shows tab_name
								-- 2: shows tab_nr + tab_name

								-- automatically updates active tab color to match color of other components (will be overidden if buffers_color is set)
								use_mode_colors = false,

								tabs_color = {
									-- same values as the general color option can be used here.
									active = "lualine_b_normal", -- color for active tab.
									inactive = "lualine_c_inactive", -- color for inactive tab.
								},

								fmt = function(name, context)
									-- show + if buffer is modified in tab
									local buflist = vim.fn.tabpagebuflist(context.tabnr)
									local winnr = vim.fn.tabpagewinnr(context.tabnr)
									local bufnr = buflist[winnr]
									local mod = vim.fn.getbufvar(bufnr, "&mod")

									return name .. (mod == 1 and " +" or "")
								end,
							},
						},
					},
					winbar = {
						lualine_a = { "filename" },
						lualine_b = { "diagnostics" },
						lualine_c = {
							{
								-- had to do this to allow the default separator to not extend to edge of scren
								function()
									return ""
								end,
								draw_empty = true,
								-- color = { bg = "black" }
								color = { bg = "#282a36" },
							},
						},
						-- lualine_x = {},
						-- lualine_y = {},
						-- lualine_z = {},
					},
					inactive_winbar = {
						lualine_a = { "filename" },
						lualine_b = { "diagnostics" },
						lualine_c = {
							{
								function()
									return ""
								end,
								draw_empty = true,
								color = { bg = "#282a36" },
							},
						},
						-- lualine_x = { function()
						--   return ''
						-- end },
						--   {'fileformat',
						--     symbols = {
						--       unix = 'unix',
						--       dos = 'dos',
						--       mac = 'mac',
						--     }},
						--   'filetype'},
						-- lualine_y = {'progress'},
						-- lualine_z = {'location'}
					},
					extensions = { "trouble" },
				})
			end,
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = false },
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- this must be after the plugin setup
-- see: https://github.com/norcalli/nvim-colorizer.lua?tab=readme-ov-file#installation-and-usage
require("colorizer").setup()

-- override the text color of the Terminal highlight group
vim.cmd([[highlight Terminal guifg=#f8f8f2]])

-- expand '.' to full path to parent dirctory of current buffer, in cmdline mode
vim.cmd([[cabbrev <expr> . expand("%:p:h")]])

vim.cmd([[
 func Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
 endfunc
]])

----------------------------
--    General Commands    --
----------------------------

-- vim.api.nvim_create_user_command('Format', 'lua vim.lsp.buf.format()', {})

-- Run these commands in the README to create a list of tools/plugins
-- vim.api.nvim_create_user_command('UpdateToolList',
--   [[.!sed -n -r -e 's/.*\{ '\''(.*)'\'',.*/- \1/p' ./lua/plugins/mason_tool_installer.lua]], {})
--
-- vim.api.nvim_create_user_command('UpdatePluginList',
--   [[.!sed -n -r -e 's/"(.*\/.*)",.*/- \[\1\]\(https:\/\/github.com\/\1\)/p' ./lua/packages.lua ]], {})

-- highlighted yank using builtin method
vim.cmd([[
  au TextYankPost * silent! lua vim.highlight.on_yank()
]])

-- terminal settings
vim.cmd([[
augroup neovim_terminal
    autocmd!
    " Enter Terminal-mode (insert) automatically
    autocmd TermOpen * startinsert
    " Disables number lines on terminal buffers
    autocmd TermOpen * :set nonumber norelativenumber
    " Set highlighting for this specific window
    autocmd TermOpen * :set winhighlight=Normal:Terminal,StatusLineNC:StatusLineTermNC,SignColumn:Terminal
augroup END
]])

----------------------------
--         Keymaps        --
----------------------------

local opts = {
	nnoremap = { noremap = true, silent = true },
	inoremap = { noremap = true, silent = true },
	vnoremap = { noremap = true, silent = true },
	xnoremap = { noremap = true, silent = true },
	tnoremap = { noremap = true, silent = true },
}

local telescope_builtin = require("telescope.builtin")
local no_preview = function()
	return require("telescope.themes").get_dropdown({
		borderchars = {
			{ "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
			results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
			preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		},
		width = 0.8,
		previewer = false,
		prompt_title = false,
	})
end

vim.keymap.set("n", "<leader>ff", function()
	telescope_builtin.find_files(no_preview())
end, opts.nnoremap)
vim.keymap.set("n", "<leader>lg", telescope_builtin.live_grep, opts.nnoremap)
vim.keymap.set("n", "<leader>g", telescope_builtin.grep_string, opts.nnoremap)

vim.keymap.set("n", "<BS>", ":nohlsearch<CR>", opts.nnoremap)
vim.keymap.set("n", "<leader>e", ":Explore<CR>", opts.nnoremap)

vim.keymap.set("n", "tn", ":tabn<CR>", opts.nnoremap)
vim.keymap.set("n", "tp", ":tabp<CR>", opts.nnoremap)

-- netrw shortcuts
-- { "v<leader>e",    ":Vexplore<CR>" },
-- { "s<leader>e",    ":Hexplore<CR>" },

-- { '<C-p>',         builtin.find_files },
-- { '<leader>b',     builtin.buffers },
-- { '<leader>fh', builtin.help_tags },

vim.keymap.set("n", [[<C-\><C-v>]], ":vsplit | term<CR>", opts.nnoremap)

vim.keymap.set("n", [[<C-\><C-s>]], ":split | term<CR>", opts.nnoremap)

vim.keymap.set("n", [[<C-\><C-t>]], ":tabnew | term<CR>", opts.nnoremap)

-- { 'gF',           utils.custom_gF },

-- { '<space>e',     vim.diagnostic.open_float },
-- { '[d',           vim.diagnostic.goto_prev },
-- { ']d',           vim.diagnostic.goto_next },
-- { '<space>q',     vim.diagnostic.setloclist },

-- Lua
-- { "<leader>xx",   function() require("trouble").toggle() end },
-- { "<leader>xw",   function() require("trouble").open("workspace_diagnostics") end },
-- { "<leader>xd",   function() require("trouble").open("document_diagnostics") end },

-- Resize with arrows
-- { "<C-Up>", ":resize +20<CR>" },
-- { "<C-Down>", ":resize -20<CR>" },
-- { "<C-Left>", ":vertical resize -20<CR>" },
-- { "<C-Right>", ":vertical resize +20<CR>" },

-- { "<F5>", ":so %<CR>" },  -- source file
-- { "<space>", "za" },  -- easy folding

-- term_mode = {
-- Terminal window navigation
-- { "<C-w>h", "<C-\\><C-N><C-w>h" },
-- { "<C-w>j", "<C-\\><C-N><C-w>j" },
-- { "<C-w>k", "<C-\\><C-N><C-w>k" },
-- { "<C-w>l", "<C-\\><C-N><C-w>l" },
--
-- { "<C-w>H", "<C-\\><C-N><C-w>H" },
-- { "<C-w>J", "<C-\\><C-N><C-w>J" },
-- { "<C-w>K", "<C-\\><C-N><C-w>K" },
-- { "<C-w>L", "<C-\\><C-N><C-w>L" },

-- },

-- visual_mode = {
--   { "<leader>y", [[:v/^\t*\/\//d<CR>]] } -- remove all non-commented lines from a selection
-- },

--   visual_block_mode = {
--     -- Move selected line / block of text in visual mode
--     { "K", ":move '<-2<CR>gv-gv" },
--     { "J", ":move '>+1<CR>gv-gv" },
--
--   },
-- }

vim.keymap.set("v", "<", "<gv", opts.vnoremap)
vim.keymap.set("v", ">", ">gv", opts.vnoremap)

vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts.xnoremap)
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts.xnoremap)

-- search and replace word under cursor
vim.keymap.set("n", "<leader>r", ":%s/<C-r><C-w>//g<Left><Left>", { noremap = true, silent = false, nowait = true })

----------------------------
--           LSP          --
----------------------------
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
})

vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					"${3rd}/luv/library",
					-- '${3rd}/busted/library'
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
vim.lsp.config("ty", {
	capabilities = capabilities,
})
vim.lsp.enable("ty") -- https://docs.astral.sh/ty/

-- vim.lsp.enable("ruff") -- https://docs.astral.sh/ruff/

vim.lsp.enable("lua_ls")

vim.lsp.enable("ansiblels")

vim.lsp.enable("bashls")

vim.lsp.enable("dockerls")

-- The file types are not detected automatically, you can register them manually (see below) or override the filetypes:
vim.filetype.add({
	extension = {
		jinja = "jinja",
		jinja2 = "jinja",
		j2 = "jinja",
	},
})

vim.lsp.enable("jinja_lsp")

require("luasnip.loaders.from_snipmate").lazy_load()

-- automatically disable virtual text if there is some diagnostic in the current line and therefore showing only virtual lines
-- See: https://www.reddit.com/r/neovim/comments/1jpbc7s/disable_virtual_text_if_there_is_diagnostic_in/?share_id=TMnSUgCygO7v9SW_qlAv4&utm_content=1&utm_medium=ios_app&utm_name=ioscss&utm_source=share&utm_term=1
vim.diagnostic.config({
	virtual_text = true,
	virtual_lines = { current_line = true },
	underline = true,
	update_in_insert = false,
})

local og_virt_text
local og_virt_line
vim.api.nvim_create_autocmd({ "CursorMoved", "DiagnosticChanged" }, {
	group = vim.api.nvim_create_augroup("diagnostic_only_virtlines", {}),
	callback = function()
		if og_virt_line == nil then
			og_virt_line = vim.diagnostic.config().virtual_lines
		end

		-- ignore if virtual_lines.current_line is disabled
		if not (og_virt_line and og_virt_line.current_line) then
			if og_virt_text then
				vim.diagnostic.config({ virtual_text = og_virt_text })
				og_virt_text = nil
			end
			return
		end

		if og_virt_text == nil then
			og_virt_text = vim.diagnostic.config().virtual_text
		end

		local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

		if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
			vim.diagnostic.config({ virtual_text = og_virt_text })
		else
			vim.diagnostic.config({ virtual_text = false })
		end
	end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
	group = vim.api.nvim_create_augroup("diagnostic_redraw", {}),
	callback = function()
		pcall(vim.diagnostic.show)
	end,
})

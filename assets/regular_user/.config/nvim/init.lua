vim.g.mapleader = " "					-- sets leader key
vim.g.netrw_banner = 0					-- gets rid of the annoying banner for netrw
vim.g.netrw_browse_split=4				-- open in prior window
vim.g.netrw_altv = 1					-- change from left splitting to right splitting
vim.g.netrw_liststyle=3					-- tree style view in netrw
--vim.cmd("let g:netrw_list_hide=netrw_gitignore#Hide()")
vim.opt.title = true					-- show title
vim.cmd('set path+=**')					-- search current directory recursively
vim.opt.syntax = "ON"
vim.opt.backup = false
vim.opt.compatible = false				-- turn off vi compatibility mode
vim.opt.number = true					-- turn on line numbers
vim.opt.relativenumber = true				-- turn on relative line numbers
vim.opt.mouse = 'a'						-- enable the mouse in all modes
vim.opt.ignorecase = true				-- enable case insensitive searching
vim.opt.smartcase = true				-- all searches are case insensitive unless there's a capital letter
vim.opt.hlsearch = false				-- disable all highlighted search results
vim.opt.incsearch = true				-- enable incremental searching
vim.opt.wrap = true						-- enable text wrapping
vim.opt.tabstop = 4						-- tabs=4spaces
vim.opt.shiftwidth = 4
vim.opt.fileencoding = "utf-8"				-- encoding set to utf-8
vim.opt.pumheight = 10					-- number of items in popup menu
vim.opt.showtabline = 2					-- always show the tab line
vim.opt.laststatus = 0					-- always show statusline
vim.opt.signcolumn = "auto"
vim.opt.expandtab = false				-- expand tab 
vim.opt.smartindent = true
vim.opt.showcmd = true
vim.opt.cmdheight = 2
vim.opt.showmode = true
vim.opt.scrolloff = 8					-- scroll page when cursor is 8 lines from top/bottom
vim.opt.sidescrolloff = 8				-- scroll page when cursor is 8 spaces from left/right
vim.opt.guifont = "monospace:h17"		
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt= { "menuone", "noselect" }
vim.opt.splitbelow = true				-- split go below
vim.opt.splitright = true				-- vertical split to the right
vim.opt.termguicolors = true			-- terminal gui colors
vim.cmd('colorscheme onedark')			-- set colorscheme
vim.cmd('filetype plugin on')			-- set filetype 
vim.cmd('set wildmenu')					-- enable wildmenu
vim.opt.undofile = true

vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.expand("~/.local/share/nvim/undo")
vim.opt.undofile = true


-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- reload config
map("n", "<leader>r", ":source ~/.config/nvim/init.lua<CR>")	-- reload neovim config

-- Tab bindings 
map("n", "<leader>t", ":tabnew<CR>")			-- space+t creates new tab
map("n", "<leader>x", ":tabclose<CR>")			-- space+x closes current tab
map("n", "<leader>j", ":tabprevious<CR>")		-- space+j moves to previous tab
map("n", "<leader>k", ":tabnext<CR>")			-- space+k moves to next tab

-- easy split generation
map("n", "<leader>v", ":vsplit")				-- space+v creates a veritcal split
map("n", "<leader>s", ":split")					-- space+s creates a horizontal split

-- easy split navigation
map("n", "<C-h>", "<C-w>h")						-- control+h switches to left split
map("n", "<C-l>", "<C-w>l")						-- control+l switches to right split
map("n", "<C-j>", "<C-w>j")						-- control+j switches to bottom split
map("n", "<C-k>", "<C-w>k")						-- control+k switches to top split

-- buffer navigation
map("n", "<Tab>", ":bnext <CR>")				-- Tab goes to next buffer
map("n", "<S-Tab>", ":bprevious <CR>")			-- Shift+Tab goes to previous buffer
map("n", "<leader>d", ":bd! <CR>")				-- Space+d delets current buffer

-- adjust split sizes easier
map("n", "<C-Left>", ":vertical resize +3<CR>")		-- Control+Left resizes vertical split +
map("n", "<C-Right>", ":vertical resize -3<CR>")	-- Control+Right resizes vertical split -

-- Open netrw in 25% split in tree view
-- map("n", "<leader>e", ":25Lex<CR>")			-- 25% netrw tree view 
map("n", "<leader>e", ":Lex 25<CR>")  -- 30 columns netrw


-- Easy way to get back to normal mode from home row

map("i", "jjk", "<Esc>")         -- jjk simulates ESC

-- Automatically close brackets, parethesis, and quotes
map("i", "'", "''<left>")
map("i", "\"", "\"\"<left>")
map("i", "(", "()<left>")
map("i", "()", "()")
map("i", "[", "[]<left>")
map("i", "{", "{}<left>")
map("i", "{;", "{};<left><left>")
-- map("i", "/*", "/**/<left><left>")

-- Visual Maps
map("v", "<leader>r", "\"hy:%s/<C-r>h//g<left><left>")			    -- Replace all instances of highlighted words 
map("v", "<C-s>", ":sort<CR>")									-- Sort highlighted text in visual mode with Control+S
map("v", "J", ":m '>+1<CR>gv=gv")								-- Move current line down
map("v", "K", ":m '>-2<CR>gv=gv")								-- Move current line up 

-- Indenting
vim.keymap.set("v", "<", "<gv", { silent = true, noremap = true })
vim.keymap.set("v", ">", ">gv", { silent = true, noremap = true })

-- Move line(s) up down in block normal and visual mode
vim.keymap.set("n", "<A-j>", ":m +1<CR>==", { silent = true, noremap = false } )
vim.keymap.set("n", "<A-k>", ":m -2<CR>==", { silent = true, noremap = false } )
-- 
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, noremap = false } )
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, noremap = false } )

-- Comments
vim.api.nvim_set_keymap("n", "<C-_>", "gcc", { noremap = false })
vim.api.nvim_set_keymap("v", "<C-_>", "gcgv", { noremap = false })


-- [[ Auto Pair ]]
local map = vim.api.nvim_set_keymap
opts = { noremap = true}
map("i", "'", "''<left>", opts)
map("i", "\"", "\"\"<left>", opts)
map("i", "(", "()<left>", opts)
map("i", "()", "()<left>", opts)
map("i", "[", "[]<left>", opts)
map("i", "{", "{}<left>", opts)
map("i", "{;", "{};<left><left>", opts)
-- map("i", "/*", "/**/<left><left>")


vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.api.nvim_create_user_command("DiagnosticToggle", function()
  local config = vim.diagnostic.config
  local vt = config().virtual_text
  config {
    virtual_text = not vt,
    underline = not vt,
    signs = not vt,
  }
end, { desc = "toggle diagnostic" })


require('Comment').setup()

-- LSP and LSP autocomplete
require('mason').setup()
require("mason-lspconfig").setup()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,
}


-- [[ Autocomplete ]]
local cmp = require("cmp")
cmp.setup {
  completion = {
    completeopt = 'menu,menuone',
    -- completeopt = 'menu,menuone,noinsert,noselect',
  },
  mapping = cmp.mapping.preset.insert({
  	['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Space>'] =  cmp.mapping.abort()
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' }
  },
}


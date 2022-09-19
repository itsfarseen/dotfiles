vim.g.mapleader = " "

vim.o.number = true
vim.cmd("filetype indent on")
vim.cmd([[set mouse=a]])

vim.cmd([[
  nnoremap q: <nop>

	inoremap jk <ESC>

  nnoremap <leader>l  :wincmd l <CR>
  nnoremap <leader>h  :wincmd h <CR>
  nnoremap <leader>k  :wincmd k <CR>
  nnoremap <leader>j  :wincmd j <CR>

  nnoremap <leader>wl  :rightbelow vsplit <CR>
  nnoremap <leader>wh  :leftabove vsplit <CR>
  nnoremap <leader>wk  :leftabove split <CR>
  nnoremap <leader>wj  :rightbelow split <CR>

  nnoremap <leader>,  :bprev <CR>
  nnoremap <leader>.  :bnext <CR>

  nnoremap <leader>;  :tabprev <CR>
  nnoremap <leader>'  :tabnext <CR>

  nnoremap <leader>:  :tabnew <CR>
  nnoremap <leader>"  :tabclose <CR>

  nnoremap <c-s> :w<CR>
  nnoremap <leader>c :close<CR>

  nnoremap <leader><leader> :noh<CR>:pclose<CR>

	tnoremap <Esc> <C-\><C-N>
]])

vim.o.completeopt = "menu,menuone,noselect"
vim.opt.signcolumn = "yes"

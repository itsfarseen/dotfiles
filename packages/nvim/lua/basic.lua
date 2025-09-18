vim.g.mapleader = " "
vim.o.exrc = true
vim.o.tabstop = 2

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

  nnoremap <C-l>  :wincmd l <CR>
  nnoremap <C-h>  :wincmd h <CR>
  nnoremap <C-k>  :wincmd k <CR>
  nnoremap <C-j>  :wincmd j <CR>

  nnoremap <leader>wl  :rightbelow vsplit <CR>
  nnoremap <leader>wh  :leftabove vsplit <CR>
  nnoremap <leader>wk  :leftabove split <CR>
  nnoremap <leader>wj  :rightbelow split <CR>

  nnoremap <C-S-l>  :rightbelow vsplit <CR>
  nnoremap <C-S-h>  :leftabove vsplit <CR>
  nnoremap <C-S-k>  :leftabove split <CR>
  nnoremap <C-S-j>  :rightbelow split <CR>

  nnoremap <leader>,  :bprev <CR>
  nnoremap <leader>.  :bnext <CR>

  nnoremap <C-,>  :bprev <CR>
  nnoremap <C-.>  :bnext <CR>

  nnoremap <leader>;  :tabprev <CR>
  nnoremap <leader>'  :tabnext <CR>

  nnoremap <leader>:  :tabnew <CR>
  nnoremap <leader>"  :tabclose <CR>

  nnoremap <c-s> :w<CR>
  nnoremap <leader>c :close<CR>
  nnoremap <C-S-d> :close<CR>
  nnoremap <leader>x <cmd>Bdelete<cr>
  nnoremap <C-S-x> <cmd>Bdelete<cr>

  nnoremap <leader><leader> :noh<CR>:pclose<CR>

	tnoremap <Esc> <C-\><C-N>

  nnoremap <leader>1 :tabn 1<CR>
  nnoremap <leader>2 :tabn 2<CR>
  nnoremap <leader>3 :tabn 3<CR>
  nnoremap <leader>4 :tabn 4<CR>
  nnoremap <leader>5 :tabn 5<CR>
  nnoremap <leader>6 :tabn 6<CR>
  nnoremap <leader>7 :tabn 7<CR>
  nnoremap <leader>8 :tabn 8<CR>
  nnoremap <leader>9 :tabn 9<CR>
  nnoremap <leader>0 :tabn 10<CR>

  nnoremap <leader>n :e notes.txt<CR>
]])

vim.o.completeopt = "menu,menuone,noselect"
vim.opt.signcolumn = "yes"
vim.opt.signcolumn = "yes"
vim.opt.signcolumn = "yes"

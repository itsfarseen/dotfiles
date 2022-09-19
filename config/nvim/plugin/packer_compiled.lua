-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/farseen/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/farseen/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/farseen/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/farseen/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/farseen/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["bufdelete.nvim"] = {
    config = { "\27LJ\2\nE\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0& nnoremap <leader>x :Bdelete<CR> \bcmd\bvim\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/bufdelete.nvim",
    url = "https://github.com/famiu/bufdelete.nvim"
  },
  ["cmp-nvim-lsp"] = {
    config = { "\27LJ\2\nŽ\1\0\0\4\0\a\0\r6\0\0\0009\0\1\0009\0\2\0009\0\3\0B\0\1\0026\1\4\0'\3\5\0B\1\2\0029\1\6\1\18\3\0\0B\1\2\2\18\0\1\0K\0\1\0\24update_capabilities\17cmp_nvim_lsp\frequire\29make_client_capabilities\rprotocol\blsp\bvim\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["copilot.vim"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["crates.nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vcrates\frequire\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/crates.nvim",
    url = "https://github.com/saecki/crates.nvim"
  },
  ["dressing.nvim"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["filetype.nvim"] = {
    config = { "\27LJ\2\n4\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\23did_load_filetypes\6g\bvim\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/filetype.nvim",
    url = "https://github.com/nathom/filetype.nvim"
  },
  ["flutter-tools.nvim"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/flutter-tools.nvim",
    url = "https://github.com/akinsho/flutter-tools.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nð\5\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0=\4\a\3=\3\t\2B\0\2\1K\0\1\0\fkeymaps\1\0\0\tn [h\1\2\1\0001&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'\texpr\2\tn ]h\1\2\1\0001&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'\texpr\2\1\0\r\17v <leader>gr\29:Gitsigns reset_hunk<CR>\17n <leader>gp#<cmd>Gitsigns preview_hunk<CR>\17n <leader>gr!<cmd>Gitsigns reset_hunk<CR>\17n <leader>gb9<cmd>lua require\"gitsigns\".blame_line{full=true}<CR>\17n <leader>gu&<cmd>Gitsigns undo_stage_hunk<CR>\17n <leader>gS#<cmd>Gitsigns stage_buffer<CR>\17v <leader>gs\29:Gitsigns stage_hunk<CR>\fnoremap\2\17n <leader>gs!<cmd>Gitsigns stage_hunk<CR>\17n <leader>gU)<cmd>Gitsigns reset_buffer_index<CR>\to ih#:<C-U>Gitsigns select_hunk<CR>\tx ih#:<C-U>Gitsigns select_hunk<CR>\17n <leader>gR#<cmd>Gitsigns reset_buffer<CR>\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["lualine-lsp-progress"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/lualine-lsp-progress",
    url = "https://github.com/arkav/lualine-lsp-progress"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\nˆ\5\0\0\5\0\31\0/6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\t\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0=\4\a\0034\4\0\0=\4\b\3=\3\n\0025\3\f\0005\4\v\0=\4\r\0035\4\14\0=\4\15\0035\4\16\0=\4\17\0035\4\18\0=\4\19\0035\4\20\0=\4\21\0035\4\22\0=\4\23\3=\3\24\0025\3\25\0004\4\0\0=\4\r\0034\4\0\0=\4\15\0035\4\26\0=\4\17\0035\4\27\0=\4\19\0034\4\0\0=\4\21\0034\4\0\0=\4\23\3=\3\28\0024\3\0\0=\3\29\0024\3\0\0=\3\30\2B\0\2\1K\0\1\0\15extensions\ftabline\22inactive_sections\1\2\0\0\rlocation\1\2\0\0\rfilename\1\0\0\rsections\14lualine_z\1\2\0\0\rlocation\14lualine_y\1\2\0\0\rprogress\14lualine_x\1\4\0\0\rencoding\15fileformat\rfiletype\14lualine_c\1\3\0\0\rfilename\17lsp_progress\14lualine_b\1\4\0\0\vbranch\tdiff\16diagnostics\14lualine_a\1\0\0\1\2\0\0\tmode\foptions\1\0\0\23disabled_filetypes\23section_separators\1\0\2\tleft\5\nright\5\25component_separators\1\0\2\tleft\5\nright\5\1\0\4\17globalstatus\1\ntheme\rnightfly\18icons_enabled\2\25always_divide_middle\2\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\nC\0\1\4\0\4\0\a6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\15lsp_expand\fluasnip\frequireì\3\1\0\t\0\31\00076\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\6\0005\4\4\0003\5\3\0=\5\5\4=\4\a\0035\4\n\0009\5\b\0009\5\t\5B\5\1\2=\5\v\0049\5\b\0009\5\f\5B\5\1\2=\5\r\0049\5\b\0009\5\14\5)\aüÿB\5\2\2=\5\15\0049\5\b\0009\5\14\5)\a\4\0B\5\2\2=\5\16\0049\5\b\0009\5\17\5B\5\1\2=\5\18\0049\5\b\0009\5\19\5B\5\1\2=\5\20\0049\5\b\0009\5\21\0055\a\24\0009\b\22\0009\b\23\b=\b\25\aB\5\2\2=\5\26\4=\4\b\0034\4\4\0005\5\27\0>\5\1\0045\5\28\0>\5\2\0045\5\29\0>\5\3\4=\4\30\3B\1\2\1K\0\1\0\fsources\1\0\1\tname\vcrates\1\0\1\tname\fluasnip\1\0\1\tname\rnvim_lsp\t<CR>\rbehavior\1\0\1\vselect\2\fReplace\20ConfirmBehavior\fconfirm\n<C-e>\nclose\14<C-Space>\rcomplete\n<C-f>\n<C-d>\16scroll_docs\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\fmapping\fsnippet\1\0\0\vexpand\1\0\0\0\nsetup\bcmp\frequire\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\nç\3\0\0\v\0\26\0)6\0\0\0'\2\1\0B\0\2\0029\0\2\0006\1\0\0'\3\3\0B\1\2\0029\1\4\0015\3\b\0005\4\6\0005\5\5\0=\5\a\4=\4\t\0035\4\20\0005\5\18\0004\6\3\0005\a\v\0005\b\n\0=\b\f\a\18\b\0\0'\n\r\0B\b\2\2=\b\14\a>\a\1\0065\a\16\0005\b\15\0=\b\f\a\18\b\0\0'\n\17\0B\b\2\2=\b\14\a>\a\2\6=\6\19\5=\5\21\4=\4\22\3B\1\2\0016\1\23\0009\1\24\1'\3\25\0B\1\2\1K\0\1\0›\1\t\t\t nnoremap <leader>e <cmd>NvimTreeOpen<cr><cmd>NvimTreeFocus<cr>\n\t\t\t nnoremap <leader>E <cmd>NvimTreeClose<cr>\n\t\t\t nnoremap <leader>o <c-w><c-p>\n\t\t \bcmd\bvim\tview\rmappings\1\0\0\tlist\1\0\0\15close_node\1\0\0\1\2\0\0\6h\acb\tedit\bkey\1\0\0\1\2\0\0\6l\ffilters\1\0\0\vcustom\1\0\0\1\2\0\0\t.git\nsetup\14nvim-tree\23nvim_tree_callback\21nvim-tree.config\frequire\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nì\3\0\0\a\0\17\1\0286\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\0\0=\3\6\0025\3\a\0004\4\0\0=\4\b\3=\3\t\0025\3\n\0005\4\v\0=\4\f\3=\3\r\0026\3\0\0'\5\1\0B\3\2\0029\3\2\0035\5\15\0005\6\14\0=\6\16\5B\3\2\0?\3\0\0B\0\2\1K\0\1\0\vindent\1\0\0\1\0\1\venable\2\26incremental_selection\fkeymaps\1\0\4\19init_selection\bgnn\22scope_incremental\bgrc\21node_incremental\bgrn\21node_decremental\bgrm\1\0\1\venable\2\14highlight\fdisable\1\0\2&additional_vim_regex_highlighting\1\venable\2\19ignore_install\21ensure_installed\1\0\1\17sync_install\1\1\r\0\0\6c\bcpp\bcss\ago\thtml\15javascript\blua\bnix\vpython\trust\15typescript\bzig\nsetup\28nvim-treesitter.configs\frequire\3€€À™\4\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23treesitter-context\frequire\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["prettier.nvim"] = {
    config = { "\27LJ\2\nª\4\0\0\4\0\t\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0006\3\4\0=\3\4\2B\0\2\0016\0\0\0'\2\5\0B\0\2\0029\0\2\0005\2\6\0005\3\a\0=\3\b\2B\0\2\1K\0\1\0\14filetypes\1\r\0\0\bcss\fgraphql\thtml\15javascript\20javascriptreact\tjson\tless\rmarkdown\tscss\15typescript\20typescriptreact\tyaml\1\0\17\14tab_width\3\2\17single_quote\1\tsemi\2\ruse_tabs\1\16quote_props\14as-needed\15prose_wrap\rpreserve\16print_width\3P\21jsx_single_quote\1\26jsx_bracket_same_line\1 html_whitespace_sensitivity\bcss\16end_of_line\alf!embedded_language_formatting\tauto\20bracket_spacing\2\17arrow_parens\valways\bbin\rprettier vue_indent_script_and_style\1\19trailing_comma\bes5\rprettier\14on_attach\1\0\0\nsetup\fnull-ls\frequire\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/prettier.nvim",
    url = "https://github.com/MunifTanjim/prettier.nvim"
  },
  ["registers.nvim"] = {
    config = { "\27LJ\2\n]\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0)\1\0\0=\1\3\0K\0\1\0\26registers_visual_mode\26registers_normal_mode\6g\bvim\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/registers.nvim",
    url = "https://github.com/tversteeg/registers.nvim"
  },
  ["rust-tools.nvim"] = {
    config = { "\27LJ\2\n¬\1\0\0\5\0\v\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\0025\3\b\0006\4\t\0=\4\t\3=\3\n\2B\0\2\1K\0\1\0\vserver\14on_attach\1\0\0\ntools\1\0\0\16inlay_hints\1\0\1\22only_current_line\1\1\0\1\17autoSetHints\2\nsetup\15rust-tools\frequire\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["stylua-nvim"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/stylua-nvim",
    url = "https://github.com/ckipp01/stylua-nvim"
  },
  ["surround.nvim"] = {
    config = { "\27LJ\2\nl\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\19mappings_style\rsandwich\26space_on_closing_char\2\nsetup\rsurround\frequire\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/surround.nvim",
    url = "https://github.com/ur4ltz/surround.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n¶\a\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0–\a\t\t\t\tnnoremap <c-p> <cmd>Telescope find_files<cr>\n\t\t\t\tnnoremap <leader>ff <cmd>Telescope find_files<cr>\n\t\t\t\tnnoremap <leader>fgg <cmd>Telescope live_grep<cr>\n\t\t\t\tnnoremap <leader>fb <cmd>Telescope buffers<cr>\n\t\t\t\tnnoremap <leader>fh <cmd>Telescope help_tags<cr>\n\t\t\t\tnnoremap <leader>fm <cmd>Telescope marks<cr>\n\t\t\t\tnnoremap <leader>fr <cmd>Telescope lsp_references<cr>\n\t\t\t\tnnoremap <leader>fs <cmd>Telescope lsp_document_symbols<cr>\n\t\t\t\tnnoremap <leader>fS <cmd>Telescope lsp_workspace_symbols<cr>\n\t\t\t\tnnoremap <leader>fa <cmd>lua vim.lsp.buf.code_action()<cr>\n\t\t\t\tnnoremap <leader>fe <cmd>Telescope diagnostics<cr>\n\t\t\t\tnnoremap <leader>fd <cmd>Telescope lsp_definitions<cr>\n\t\t\t\tnnoremap <leader>fD <cmd>Telescope lsp_type_definitions<cr>\n\t\t\t\tnnoremap <leader>fi <cmd>Telescope lsp_implementations<cr>\n\t\t\t\tnnoremap <leader>fgs <cmd>Telescope git_status<cr>\n\t\t\t\tnnoremap <leader>ft <cmd>Telescope treesitter<cr>\n\t\t\t\bcmd\bvim\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    config = { "\27LJ\2\n²\1\0\0\3\0\b\0\0176\0\0\0009\0\1\0+\1\1\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\3\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\6\0'\2\a\0B\0\2\1K\0\1\0\27colorscheme tokyonight\bcmd\nstorm\21tokyonight_style\28tokyonight_dark_sidebar\27tokyonight_transparent\6g\bvim\0" },
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/vim-abolish",
    url = "https://github.com/tpope/vim-abolish"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/vim-polyglot",
    url = "https://github.com/sheerun/vim-polyglot"
  },
  ["zepl.vim"] = {
    loaded = true,
    path = "/home/farseen/.local/share/nvim/site/pack/packer/start/zepl.vim",
    url = "https://github.com/axvr/zepl.vim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\nˆ\5\0\0\5\0\31\0/6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\t\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0=\4\a\0034\4\0\0=\4\b\3=\3\n\0025\3\f\0005\4\v\0=\4\r\0035\4\14\0=\4\15\0035\4\16\0=\4\17\0035\4\18\0=\4\19\0035\4\20\0=\4\21\0035\4\22\0=\4\23\3=\3\24\0025\3\25\0004\4\0\0=\4\r\0034\4\0\0=\4\15\0035\4\26\0=\4\17\0035\4\27\0=\4\19\0034\4\0\0=\4\21\0034\4\0\0=\4\23\3=\3\28\0024\3\0\0=\3\29\0024\3\0\0=\3\30\2B\0\2\1K\0\1\0\15extensions\ftabline\22inactive_sections\1\2\0\0\rlocation\1\2\0\0\rfilename\1\0\0\rsections\14lualine_z\1\2\0\0\rlocation\14lualine_y\1\2\0\0\rprogress\14lualine_x\1\4\0\0\rencoding\15fileformat\rfiletype\14lualine_c\1\3\0\0\rfilename\17lsp_progress\14lualine_b\1\4\0\0\vbranch\tdiff\16diagnostics\14lualine_a\1\0\0\1\2\0\0\tmode\foptions\1\0\0\23disabled_filetypes\23section_separators\1\0\2\tleft\5\nright\5\25component_separators\1\0\2\tleft\5\nright\5\1\0\4\17globalstatus\1\ntheme\rnightfly\18icons_enabled\2\25always_divide_middle\2\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: prettier.nvim
time([[Config for prettier.nvim]], true)
try_loadstring("\27LJ\2\nª\4\0\0\4\0\t\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0006\3\4\0=\3\4\2B\0\2\0016\0\0\0'\2\5\0B\0\2\0029\0\2\0005\2\6\0005\3\a\0=\3\b\2B\0\2\1K\0\1\0\14filetypes\1\r\0\0\bcss\fgraphql\thtml\15javascript\20javascriptreact\tjson\tless\rmarkdown\tscss\15typescript\20typescriptreact\tyaml\1\0\17\14tab_width\3\2\17single_quote\1\tsemi\2\ruse_tabs\1\16quote_props\14as-needed\15prose_wrap\rpreserve\16print_width\3P\21jsx_single_quote\1\26jsx_bracket_same_line\1 html_whitespace_sensitivity\bcss\16end_of_line\alf!embedded_language_formatting\tauto\20bracket_spacing\2\17arrow_parens\valways\bbin\rprettier vue_indent_script_and_style\1\19trailing_comma\bes5\rprettier\14on_attach\1\0\0\nsetup\fnull-ls\frequire\0", "config", "prettier.nvim")
time([[Config for prettier.nvim]], false)
-- Config for: registers.nvim
time([[Config for registers.nvim]], true)
try_loadstring("\27LJ\2\n]\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0)\1\0\0=\1\3\0K\0\1\0\26registers_visual_mode\26registers_normal_mode\6g\bvim\0", "config", "registers.nvim")
time([[Config for registers.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\nC\0\1\4\0\4\0\a6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\15lsp_expand\fluasnip\frequireì\3\1\0\t\0\31\00076\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\6\0005\4\4\0003\5\3\0=\5\5\4=\4\a\0035\4\n\0009\5\b\0009\5\t\5B\5\1\2=\5\v\0049\5\b\0009\5\f\5B\5\1\2=\5\r\0049\5\b\0009\5\14\5)\aüÿB\5\2\2=\5\15\0049\5\b\0009\5\14\5)\a\4\0B\5\2\2=\5\16\0049\5\b\0009\5\17\5B\5\1\2=\5\18\0049\5\b\0009\5\19\5B\5\1\2=\5\20\0049\5\b\0009\5\21\0055\a\24\0009\b\22\0009\b\23\b=\b\25\aB\5\2\2=\5\26\4=\4\b\0034\4\4\0005\5\27\0>\5\1\0045\5\28\0>\5\2\0045\5\29\0>\5\3\4=\4\30\3B\1\2\1K\0\1\0\fsources\1\0\1\tname\vcrates\1\0\1\tname\fluasnip\1\0\1\tname\rnvim_lsp\t<CR>\rbehavior\1\0\1\vselect\2\fReplace\20ConfirmBehavior\fconfirm\n<C-e>\nclose\14<C-Space>\rcomplete\n<C-f>\n<C-d>\16scroll_docs\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\fmapping\fsnippet\1\0\0\vexpand\1\0\0\0\nsetup\bcmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: rust-tools.nvim
time([[Config for rust-tools.nvim]], true)
try_loadstring("\27LJ\2\n¬\1\0\0\5\0\v\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\0025\3\b\0006\4\t\0=\4\t\3=\3\n\2B\0\2\1K\0\1\0\vserver\14on_attach\1\0\0\ntools\1\0\0\16inlay_hints\1\0\1\22only_current_line\1\1\0\1\17autoSetHints\2\nsetup\15rust-tools\frequire\0", "config", "rust-tools.nvim")
time([[Config for rust-tools.nvim]], false)
-- Config for: crates.nvim
time([[Config for crates.nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vcrates\frequire\0", "config", "crates.nvim")
time([[Config for crates.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\nç\3\0\0\v\0\26\0)6\0\0\0'\2\1\0B\0\2\0029\0\2\0006\1\0\0'\3\3\0B\1\2\0029\1\4\0015\3\b\0005\4\6\0005\5\5\0=\5\a\4=\4\t\0035\4\20\0005\5\18\0004\6\3\0005\a\v\0005\b\n\0=\b\f\a\18\b\0\0'\n\r\0B\b\2\2=\b\14\a>\a\1\0065\a\16\0005\b\15\0=\b\f\a\18\b\0\0'\n\17\0B\b\2\2=\b\14\a>\a\2\6=\6\19\5=\5\21\4=\4\22\3B\1\2\0016\1\23\0009\1\24\1'\3\25\0B\1\2\1K\0\1\0›\1\t\t\t nnoremap <leader>e <cmd>NvimTreeOpen<cr><cmd>NvimTreeFocus<cr>\n\t\t\t nnoremap <leader>E <cmd>NvimTreeClose<cr>\n\t\t\t nnoremap <leader>o <c-w><c-p>\n\t\t \bcmd\bvim\tview\rmappings\1\0\0\tlist\1\0\0\15close_node\1\0\0\1\2\0\0\6h\acb\tedit\bkey\1\0\0\1\2\0\0\6l\ffilters\1\0\0\vcustom\1\0\0\1\2\0\0\t.git\nsetup\14nvim-tree\23nvim_tree_callback\21nvim-tree.config\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: bufdelete.nvim
time([[Config for bufdelete.nvim]], true)
try_loadstring("\27LJ\2\nE\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0& nnoremap <leader>x :Bdelete<CR> \bcmd\bvim\0", "config", "bufdelete.nvim")
time([[Config for bufdelete.nvim]], false)
-- Config for: surround.nvim
time([[Config for surround.nvim]], true)
try_loadstring("\27LJ\2\nl\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\19mappings_style\rsandwich\26space_on_closing_char\2\nsetup\rsurround\frequire\0", "config", "surround.nvim")
time([[Config for surround.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nì\3\0\0\a\0\17\1\0286\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\0\0=\3\6\0025\3\a\0004\4\0\0=\4\b\3=\3\t\0025\3\n\0005\4\v\0=\4\f\3=\3\r\0026\3\0\0'\5\1\0B\3\2\0029\3\2\0035\5\15\0005\6\14\0=\6\16\5B\3\2\0?\3\0\0B\0\2\1K\0\1\0\vindent\1\0\0\1\0\1\venable\2\26incremental_selection\fkeymaps\1\0\4\19init_selection\bgnn\22scope_incremental\bgrc\21node_incremental\bgrn\21node_decremental\bgrm\1\0\1\venable\2\14highlight\fdisable\1\0\2&additional_vim_regex_highlighting\1\venable\2\19ignore_install\21ensure_installed\1\0\1\17sync_install\1\1\r\0\0\6c\bcpp\bcss\ago\thtml\15javascript\blua\bnix\vpython\trust\15typescript\bzig\nsetup\28nvim-treesitter.configs\frequire\3€€À™\4\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: cmp-nvim-lsp
time([[Config for cmp-nvim-lsp]], true)
try_loadstring("\27LJ\2\nŽ\1\0\0\4\0\a\0\r6\0\0\0009\0\1\0009\0\2\0009\0\3\0B\0\1\0026\1\4\0'\3\5\0B\1\2\0029\1\6\1\18\3\0\0B\1\2\2\18\0\1\0K\0\1\0\24update_capabilities\17cmp_nvim_lsp\frequire\29make_client_capabilities\rprotocol\blsp\bvim\0", "config", "cmp-nvim-lsp")
time([[Config for cmp-nvim-lsp]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n¶\a\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0–\a\t\t\t\tnnoremap <c-p> <cmd>Telescope find_files<cr>\n\t\t\t\tnnoremap <leader>ff <cmd>Telescope find_files<cr>\n\t\t\t\tnnoremap <leader>fgg <cmd>Telescope live_grep<cr>\n\t\t\t\tnnoremap <leader>fb <cmd>Telescope buffers<cr>\n\t\t\t\tnnoremap <leader>fh <cmd>Telescope help_tags<cr>\n\t\t\t\tnnoremap <leader>fm <cmd>Telescope marks<cr>\n\t\t\t\tnnoremap <leader>fr <cmd>Telescope lsp_references<cr>\n\t\t\t\tnnoremap <leader>fs <cmd>Telescope lsp_document_symbols<cr>\n\t\t\t\tnnoremap <leader>fS <cmd>Telescope lsp_workspace_symbols<cr>\n\t\t\t\tnnoremap <leader>fa <cmd>lua vim.lsp.buf.code_action()<cr>\n\t\t\t\tnnoremap <leader>fe <cmd>Telescope diagnostics<cr>\n\t\t\t\tnnoremap <leader>fd <cmd>Telescope lsp_definitions<cr>\n\t\t\t\tnnoremap <leader>fD <cmd>Telescope lsp_type_definitions<cr>\n\t\t\t\tnnoremap <leader>fi <cmd>Telescope lsp_implementations<cr>\n\t\t\t\tnnoremap <leader>fgs <cmd>Telescope git_status<cr>\n\t\t\t\tnnoremap <leader>ft <cmd>Telescope treesitter<cr>\n\t\t\t\bcmd\bvim\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-treesitter-context
time([[Config for nvim-treesitter-context]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23treesitter-context\frequire\0", "config", "nvim-treesitter-context")
time([[Config for nvim-treesitter-context]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\nð\5\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0=\4\a\3=\3\t\2B\0\2\1K\0\1\0\fkeymaps\1\0\0\tn [h\1\2\1\0001&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'\texpr\2\tn ]h\1\2\1\0001&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'\texpr\2\1\0\r\17v <leader>gr\29:Gitsigns reset_hunk<CR>\17n <leader>gp#<cmd>Gitsigns preview_hunk<CR>\17n <leader>gr!<cmd>Gitsigns reset_hunk<CR>\17n <leader>gb9<cmd>lua require\"gitsigns\".blame_line{full=true}<CR>\17n <leader>gu&<cmd>Gitsigns undo_stage_hunk<CR>\17n <leader>gS#<cmd>Gitsigns stage_buffer<CR>\17v <leader>gs\29:Gitsigns stage_hunk<CR>\fnoremap\2\17n <leader>gs!<cmd>Gitsigns stage_hunk<CR>\17n <leader>gU)<cmd>Gitsigns reset_buffer_index<CR>\to ih#:<C-U>Gitsigns select_hunk<CR>\tx ih#:<C-U>Gitsigns select_hunk<CR>\17n <leader>gR#<cmd>Gitsigns reset_buffer<CR>\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: filetype.nvim
time([[Config for filetype.nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\23did_load_filetypes\6g\bvim\0", "config", "filetype.nvim")
time([[Config for filetype.nvim]], false)
-- Config for: tokyonight.nvim
time([[Config for tokyonight.nvim]], true)
try_loadstring("\27LJ\2\n²\1\0\0\3\0\b\0\0176\0\0\0009\0\1\0+\1\1\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\3\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\6\0'\2\a\0B\0\2\1K\0\1\0\27colorscheme tokyonight\bcmd\nstorm\21tokyonight_style\28tokyonight_dark_sidebar\27tokyonight_transparent\6g\bvim\0", "config", "tokyonight.nvim")
time([[Config for tokyonight.nvim]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end

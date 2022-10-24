require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    tag = 'nightly'
  }

  use 'itchyny/lightline.vim'

  use 'rubixninja314/vim-mcfunction'

  use 'rust-lang/rust.vim'
  use 'vim-syntastic/syntastic'

  use 'tjdevries/nlua.nvim'
  use 'euclidianAce/BetterLua.vim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use 'nvim-telescope/telescope-fzf-native.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-treesitter/nvim-treesitter'

  use 'ervandew/supertab'

end)


require('nvim-tree').setup{}
cmd('highlight NvimTreeFolderIcon guibg=blue')




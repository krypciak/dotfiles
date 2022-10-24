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

  use 'vim-syntastic/syntastic'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use 'nvim-telescope/telescope-fzf-native.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-treesitter/nvim-treesitter'

end)


require('nvim-tree').setup{}
cmd('highlight NvimTreeFolderIcon guibg=blue')




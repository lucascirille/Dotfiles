return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      CustomOilBar = function()
        local path = vim.fn.expand '%'
        path = path:gsub('oil://', '')

        return '  ' .. vim.fn.fnamemodify(path, ':.')
      end

      require('oil').setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<C-l>'] = false,
          ['<C-k>'] = false,
          ['<C-j>'] = false,
          ['<M-h>'] = 'actions.select_split',
          ['<Tab>'] = 'actions.select',
        },
        win_options = {
          winbar = '%{v:lua.CustomOilBar()}',
        },
        view_options = {
          show_hidden = true,
        },
      }

      -- Open parent directory in current window
      vim.keymap.set('n', '|', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      -- Open child directory in current window
      vim.keymap.set('n', '<Tab>', '<CMD>Oil<CR>', { desc = 'Open child directory' })

      -- Open parent directory in floating window
      vim.keymap.set('n', '<space>-', require('oil').toggle_float)

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'oil://*',
        callback = function()
          -- Obtiene la ruta del directorio actual dentro de oil.nvim
          local path = vim.fn.expand '%:p:h'
          -- Elimina el prefijo 'oil://' de la ruta
          local file_path = path:gsub('oil://', '')
          -- Verifica si la ruta es válida antes de intentar cambiar de directorio
          if vim.fn.isdirectory(file_path) == 1 then
            -- Cambia el directorio de trabajo de Neovim al directorio actual de oil.nvim
            vim.fn.chdir(file_path)
          else
            print('Error: No se pudo cambiar al directorio ' .. file_path)
          end
        end,
      })
    end,
  },
}

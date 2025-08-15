return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = vim.g.have_nerd_font and 1 or 0
    vim.g.db_ui_winwidth = 50
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_save_location = vim.fn.stdpath 'data' .. '/dadbod_ui'
    vim.g.db_ui_tmp_query_location = vim.fn.stdpath 'cache' .. '/dadbod_ui'
    vim.g.db_ui_show_database_icon = 1
    vim.g.db_ui_notification_style = 'notify'
  end,
  config = function()
    -- Auto-load DB_CONNECTION_STRING if available
    local db_connection = vim.fn.getenv 'DB_CONNECTION_STRING'
    if db_connection and db_connection ~= vim.NIL then
      vim.g.dbs = {
        default = db_connection,
      }
    end
  end,
  keys = {
    { '<leader>db', '<cmd>DBUIToggle<cr>', desc = '󰆼 Toggle DBUI' },
    { '<leader>df', '<cmd>DBUIFindBuffer<cr>', desc = '󰆼 Find DB buffer' },
    { '<leader>dr', '<cmd>DBUIRenameBuffer<cr>', desc = '󰆼 Rename DB buffer' },
    { '<leader>dl', '<cmd>DBUILastQueryInfo<cr>', desc = '󰆼 Last query info' },
    { '<leader>dx', '<Plug>(DBUI_ExecuteQuery)', desc = '󰆼 Execute query' },
    { '<leader>dt', '<Plug>(DBUI_ToggleDetails)', desc = '󰆼 Toggle results' },
    { '<leader>ds', '<Plug>(DBUI_SaveQuery)', desc = '󰆼 Save query' },
    { '<leader>de', '<Plug>(DBUI_EditBindParameters)', desc = '󰆼 Edit params' },
  },
}

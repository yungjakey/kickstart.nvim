return {
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    dependencies = {
      '3rd/image.nvim',
      'tpope/vim-repeat', -- Add this for dot repeat support
    },
    build = ':UpdateRemotePlugins',
    lazy = false,
    init = function()
      -- Helper function to get python path from poetry/pyproject
      local function get_python_kernel()
        local poetry_env = vim.fn.trim(vim.fn.system 'poetry env info --path 2>/dev/null')
        if vim.v.shell_error == 0 and poetry_env ~= '' then
          local python_path = poetry_env .. '/bin/python'
          if vim.fn.executable(python_path) == 1 then
            return python_path
          end
        end
        return 'python3'
      end

      -- Set python path early
      vim.g.python3_host_prog = get_python_kernel()

      -- Molten configuration
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true -- Changed to true for easier debugging
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_cover_empty_lines = false -- Don't cover empty lines
      vim.g.molten_use_border_highlights = true
      vim.g.molten_output_show_more = true
      vim.g.molten_enter_output_behavior = 'open_and_enter'
    end,
    config = function()
      -- Enhanced keymaps with better error handling
      vim.keymap.set('n', '<leader>mm', function()
        vim.cmd 'MoltenInit python3'
        print 'Molten initialized with python3'
      end, { desc = 'Initialize Molten' })

      vim.keymap.set('n', '<leader>mo', ':MoltenEvaluateOperator<CR>', { desc = 'Run operator selection' })
      vim.keymap.set('n', '<leader>ml', ':MoltenEvaluateLine<CR>', { desc = 'Evaluate line' })
      vim.keymap.set('v', '<leader>mv', ':<C-u>MoltenEvaluateVisual<CR>', { desc = 'Evaluate visual selection' })
      vim.keymap.set('n', '<leader>mr', ':MoltenReevaluateCell<CR>', { desc = 'Re-evaluate cell' })
      vim.keymap.set('n', '<leader>md', ':MoltenDelete<CR>', { desc = 'Delete Molten cell' })
      vim.keymap.set('n', '<leader>ms', ':MoltenShowOutput<CR>', { desc = 'Show output' })
      vim.keymap.set('n', '<leader>mh', ':MoltenHideOutput<CR>', { desc = 'Hide output' })
      vim.keymap.set('n', '<leader>mc', function()
        -- Find paragraph boundaries
        local current_line = vim.api.nvim_win_get_cursor(0)[1]
        local total_lines = vim.api.nvim_buf_line_count(0)

        -- Find start of paragraph
        local para_start = current_line
        while para_start > 1 do
          local line = vim.api.nvim_buf_get_lines(0, para_start - 2, para_start - 1, false)[1]
          if not line or vim.trim(line) == '' then
            break
          end
          para_start = para_start - 1
        end

        -- Find end of paragraph
        local para_end = current_line
        while para_end < total_lines do
          local line = vim.api.nvim_buf_get_lines(0, para_end, para_end + 1, false)[1]
          if not line or vim.trim(line) == '' then
            break
          end
          para_end = para_end + 1
        end

        vim.fn.MoltenEvaluateRange(para_start, para_end)
        vim.cmd 'normal! <Esc>'

        -- vim.fn['repeat#set'](vim.api.nvim_replace_termcodes('<leader>mc', true, false, true))
      end, { desc = 'Run current paragraph' })
      vim.keymap.set('n', '<leader>ma', function()
        local total_lines = vim.api.nvim_buf_line_count(0)
        local cells = {}
        local current_cell_start = 1

        -- Find all cell boundaries
        for i = 1, total_lines do
          local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
          if line and line:match '^# %%' then
            -- If this isn't the first cell marker, save the previous cell
            if i > 1 then
              table.insert(cells, { start = current_cell_start, end_line = i - 1 })
            end
            current_cell_start = i + 1
          end
        end

        -- Add the last cell (from last marker to end of file)
        if current_cell_start <= total_lines then
          table.insert(cells, { start = current_cell_start, end_line = total_lines })
        end

        -- If no cell markers found, treat entire file as one cell
        if #cells == 0 then
          table.insert(cells, { start = 1, end_line = total_lines })
        end

        -- Execute all cells sequentially
        for i, cell in ipairs(cells) do
          -- Skip empty cells
          local has_content = false
          for line_num = cell.start, cell.end_line do
            local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
            if line and vim.trim(line) ~= '' then
              has_content = true
              break
            end
          end

          if has_content then
            vim.fn.MoltenEvaluateRange(cell.start, cell.end_line)

            -- Small delay between cells to avoid overwhelming the kernel
            if i < #cells then
              vim.cmd 'sleep 100m'
            end
          end
        end

        vim.notify('Executed ' .. #cells .. ' cells', vim.log.levels.INFO)
      end, { desc = 'Run all cells' })

      -- Alternative: Run from current cell to end
      vim.keymap.set('n', '<leader>mA', function()
        local current_line = vim.api.nvim_win_get_cursor(0)[1]
        local total_lines = vim.api.nvim_buf_line_count(0)
        local cells = {}
        local current_cell_start = 1
        local found_current = false

        -- Find current cell and all cells after it
        for i = 1, total_lines do
          local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
          if line and line:match '^# %%' then
            -- If we've passed the current line, start collecting cells
            if i >= current_line and not found_current then
              found_current = true
              current_cell_start = i + 1
            elseif found_current and i > current_line then
              table.insert(cells, { start = current_cell_start, end_line = i - 1 })
              current_cell_start = i + 1
            end
          end
        end

        -- Add the last cell if we found the current cell
        if found_current and current_cell_start <= total_lines then
          table.insert(cells, { start = current_cell_start, end_line = total_lines })
        end

        -- If no cells found after current position, just run from current cell to end
        if #cells == 0 then
          -- Find start of current cell
          local cell_start = 1
          for i = current_line, 1, -1 do
            local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
            if line and line:match '^# %%' then
              cell_start = i + 1
              break
            end
          end

          -- Find end (next cell marker or end of file)
          local cell_end = total_lines
          for i = current_line + 1, total_lines do
            local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
            if line and line:match '^# %%' then
              cell_end = i - 1
              break
            end
          end

          table.insert(cells, { start = cell_start, end_line = cell_end })
        end

        -- Execute all cells from current position
        for i, cell in ipairs(cells) do
          vim.fn.MoltenEvaluateRange(cell.start, cell.end_line)

          if i < #cells then
            vim.cmd 'sleep 100m'
          end
        end

        vim.notify('Executed ' .. #cells .. ' cells from current position', vim.log.levels.INFO)
      end, { desc = 'Run all cells from current position' })

      -- Run all cells above current position
      vim.keymap.set('n', '<leader>mB', function()
        local current_line = vim.api.nvim_win_get_cursor(0)[1]
        local cells = {}
        local current_cell_start = 1

        -- Find all cells before current position
        for i = 1, current_line do
          local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
          if line and line:match '^# %%' then
            if i > 1 then
              table.insert(cells, { start = current_cell_start, end_line = i - 1 })
            end
            current_cell_start = i + 1
          end
        end

        -- Add the current cell if it's not empty
        if current_cell_start < current_line then
          table.insert(cells, { start = current_cell_start, end_line = current_line })
        end

        -- Execute all cells before current position
        for i, cell in ipairs(cells) do
          vim.fn.MoltenEvaluateRange(cell.start, cell.end_line)

          if i < #cells then
            vim.cmd 'sleep 100m'
          end
        end

        vim.notify('Executed ' .. #cells .. ' cells before current position', vim.log.levels.INFO)
      end, { desc = 'Run all cells before current position' })

      vim.keymap.set('n', ']j', function()
        local current_line = vim.api.nvim_win_get_cursor(0)[1]
        local total_lines = vim.api.nvim_buf_line_count(0)

        -- Search for next cell marker AFTER current line
        for i = current_line + 1, total_lines do
          local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
          if line and line:match '^# %%' then
            vim.api.nvim_win_set_cursor(0, { i + 1, 0 }) -- Move to line after marker
            return
          end
        end

        -- vim.fn['repeat#set'](vim.api.nvim_replace_termcodes(']j', true, false, true))
      end, { desc = 'Next cell' })

      vim.keymap.set('n', '[j', function()
        local current_line = vim.api.nvim_win_get_cursor(0)[1]

        -- Find the current cell's start marker first
        local current_cell_start = nil
        for i = current_line, 1, -1 do
          local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
          if line and line:match '^# %%' then
            current_cell_start = i
            break
          end
        end

        -- Now search for previous cell marker BEFORE current cell's start
        if current_cell_start then
          for i = current_cell_start - 1, 1, -1 do
            local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
            if line and line:match '^# %%' then
              vim.api.nvim_win_set_cursor(0, { i + 1, 0 }) -- Move to line after marker
              return
            end
          end
        end

        vim.fn['repeat#set'](vim.api.nvim_replace_termcodes('[j', true, false, true))
      end, { desc = 'Previous cell' })

      -- Insert cell markers
      vim.keymap.set('n', '<leader>mi', function()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, line - 1, line - 1, false, { '# %%' })
      end, { desc = 'Insert cell marker' })

      -- Debug command to check Molten status
      vim.keymap.set('n', '<leader>mM', function()
        vim.cmd 'MoltenInfo'
        print('Python path: ' .. vim.g.python3_host_prog)
        print('Jupyter available: ' .. (vim.fn.executable 'jupyter' == 1 and 'yes' or 'no'))
      end, { desc = 'Check Molten status' })
      -- Enhanced auto-detection
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = '*.py',
        callback = function()
          local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
          for _, line in ipairs(lines) do
            if line:match '^# %%%%' or line:match '^#%%%%' then
              vim.bo.filetype = 'python'
              vim.schedule(function()
                vim.cmd 'MoltenInit python3'
                print 'Auto-initialized Molten for notebook file'
              end)
              break
            end
          end
        end,
      })
    end,
  },
  {
    '3rd/image.nvim',
    opts = {
      backend = 'kitty',
      integrations = {},
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
    version = '1.1.0',
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    'GCBallesteros/jupytext.nvim',
    config = true,
    lazy = false,
  },
}

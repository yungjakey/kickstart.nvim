return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return { timeout_ms = 500, lsp_format = 'fallback' }
        end
      end,
      formatters_by_ft = {
        json = { 'fixjson', 'prettierd' },
        jsonc = { 'fixjson', 'prettierd' },
        yaml = { 'yamlfix', 'prettierd' },
        yml = { 'yamlfix', 'prettierd' },
        python = { 'ruff_fix', 'ruff_format' },
        go = { 'goimports' },
        bash = { 'shfmt' },
        sh = { 'shfmt' },
        zsh = { 'shfmt' },
        lua = { 'stylua' },
        sql = { 'sqlfluff' },
        j2sql = { 'djlint', 'sqlfluff' },
        j2 = { 'djlint' },
        jinja2 = { 'djlint' },
        terraform = { 'tofu_fmt' },
        hcl = { 'tofu_fmt' },
        tfvars = { 'tofu_fmt' },
        dockerfile = { 'dockerfmt' },
        markdown = { 'prettierd' },
      },
      formatters = {
        djlint = {
          command = 'djlint',
          args = { '--reformat', '-' },
          stdin = true,
        },
      },
    },
  },
}

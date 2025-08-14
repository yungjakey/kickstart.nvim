vim.filetype.add {
  pattern = {
    ['.*%.sql%.j2$'] = 'j2sql',
    ['.*%.sql%.jinja2$'] = 'j2sql',
  },
  extension = {
    j2 = function(path, bufnr)
      if path:match '%.sql%.j2$' then
        return 'j2sql'
      end
      return 'jinja2'
    end,
    jinja2 = function(path, bufnr)
      if path:match '%.sql%.jinja2$' then
        return 'j2sql'
      end
      return 'jinja2'
    end,
  },
}

vim.filetype.add {
  pattern = { ['.*-query-[^%.]*'] = 'sql' },
}

vim.filetype.add {
  filename = {
    ['.zshrc'] = 'bash',
    ['.zshenv'] = 'bash',
    ['.zprofile'] = 'bash',
    ['.zlogin'] = 'bash',
  },
  pattern = {
    ['.*%.zsh'] = 'bash',
  },
}

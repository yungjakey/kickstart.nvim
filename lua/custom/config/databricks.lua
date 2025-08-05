local M = {}

M.setup = function()
    -- Get poetry python path
    local poetry_env = vim.fn.trim(vim.fn.system('poetry env info --path 2>/dev/null'))
    if vim.v.shell_error == 0 and poetry_env ~= '' then
        vim.g.python3_host_prog = poetry_env .. '/bin/python'
    else
        vim.g.python3_host_prog = vim.fn.exepath('python3')
    end
end

M.get_databricks_profile = function()
    local profile = os.getenv('DATABRICKS_CONFIG_PROFILE') or 'DEFAULT'
    return profile
end

M.init_databricks_kernel = function()
    local profile = M.get_databricks_profile()

    -- Use databricks auth env to get current auth context
    local auth_env = vim.fn.system('databricks auth env --profile ' .. profile .. ' 2>/dev/null')

    if vim.v.shell_error == 0 then
        vim.cmd('MoltenInit python3')
    end
end

return M

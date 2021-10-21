local M = {}
local handlers = {}

M.setup = function()
  vim.cmd([[
    command! PluginUpdateAll lua require('plugin-manager').update_all()
  ]])
  return M
end

M.use = function(opts)
  local plugin_name = type(opts) == 'string' and opts or opts[1]
  local config = type(opts) == 'table' and type(opts.config) == 'function' and opts.config or function() end
  local plugin_path = vim.fn.stdpath('data')..'/site/pack/plugins/start/'..plugin_name
  if vim.fn.empty(vim.fn.glob(plugin_path)) > 0 then
    handlers[plugin_name] = vim.loop.spawn(
      'git',
      {args = {'clone', '--depth', '1', 'https://github.com/'..plugin_name, plugin_path}},
      function()
        print('GitHub plugin "'..plugin_name..'" installed!')
        handlers[plugin_name]:close()
      end
    )
  else
    vim.cmd('packadd '..plugin_name)
    config()
  end
end

M.update_all = function()
  local plugins_glob = vim.fn.stdpath('data')..'/site/pack/plugins/start/*/*'
  local plugins_paths = vim.fn.split(vim.fn.glob(plugins_glob))
  local total_plugins_to_update = #plugins_paths
  local total_plugins_updated = 0

  print('Updated plugins: 0/'..total_plugins_to_update)
  for idx, path in ipairs(plugins_paths) do
    handlers[idx] = vim.loop.spawn(
      'git',
      {args = {'-C', path, 'pull'}},
      function()
        total_plugins_updated = total_plugins_updated + 1
        print('Updated plugins: '..total_plugins_updated..'/'..total_plugins_to_update)
        handlers[idx]:close()
      end
    )
  end
end

return M

return function(module_name)
  local ok, err = pcall(require, 'modules.'..module_name)
  if not ok then
    print('Could not load module "'..module_name..'":')
    print(err)
  end
end

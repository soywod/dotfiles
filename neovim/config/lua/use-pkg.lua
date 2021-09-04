return function(pkg_name)
  local ok, err = pcall(require, 'pkgs.'..pkg_name)
  if not ok then
    print('Could not use package "'..pkg_name..'":')
    print(err)
  end
end

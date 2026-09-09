function windowUISync(args)
  if (USER_PERMISSIONS[args[1]] or 1) > 2 then clubhouse.sync(args[1]) end
end

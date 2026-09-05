function initUsersPermissions()
  local mapXML = tfm.get.room.xmlMapInfo.xml
  print(#mapXML)

  local pTag = string.match(mapXML, '<C><P%s+([^>]+)/')
  local users = string.match(pTag, 'USER_PERMISSIONS="([^"]+)"')

  -- USER_PERMISSIONS = {}
  for entry in users:gmatch("[^,]+") do
    local user, level = entry:match("%s*(.-)%s*=%s*(%d+)")
    level = tonumber(level)

    if user and level then
      if user == roomCreator.name then
        if roomCreator.adminRevoked then
          level = level > 2 and level or 1
        else
          level = math.max(level, 2)
        end
      end
      USER_PERMISSIONS[user] = level
    end
  end
end

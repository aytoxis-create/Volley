function lobbyMapConfig()
  local mapXML = tfm.get.room.xmlMapInfo.xml
  print(#mapXML)

  local pTag = string.match(mapXML, '<C><P%s+([^>]+)/')
  local users = string.match(pTag, 'BAN="([^"]+)"')

  timestamp = tonumber(string.match(pTag, 'TIMESTAMP="([^"]+)"'))

  print(timestamp)

  -- USER_PERMISSIONS = {}
  for entry in users:gmatch("[^,]+") do
    local user = entry

    if user then
      playerBanHistory[user] = "VOLLEY SYSTEM"
      playerBan[user] = true
    end
  end

  for name, data in pairs(tfm.get.room.playerList) do
    if playerBan[name] then
      print("kick "..name.."")
      tfm.exec.kickPlayer(name)
    end

    if not playerBan[name] and timestamp ~= 0 then
      if tfm.get.room.playerList[name].registrationDate > timestamp then
        print("kick "..name.."")
        tfm.exec.kickPlayer(name)
      end
    end
  end
end
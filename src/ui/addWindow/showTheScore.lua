function showTheScore()
  clubhouse.clear(nil,"score")
  if mode ~= "gameStart" then return end
  -- Retire the old map-relative score textareas, including Real Mode counters.
  for _,id in ipairs({0,1,899899,8998991}) do ui.removeTextArea(id) end
  local colors = {red="#E85A71",blue="#4BA9EF",yellow="#E5CC4B",green="#49CF82"}
  local tagColors = {["<r>"]=colors.red,["<bv>"]=colors.blue,["<j>"]=colors.yellow,["<vp>"]=colors.green}
  local entries = {}
  local function add(value,color,x,detail,detailX)
    entries[#entries+1] = {value=value,color=color,x=x,detail=detail,detailX=detailX}
  end
  if gameStats.realMode then
    add(teamsScores.red,colors.red,1150,gameStats.redQuantitySpawn.."/"..gameStats.redLimitSpawn,200)
    add(teamsScores.blue,colors.blue,1350,gameStats.blueQuantitySpawn.."/"..gameStats.blueLimitSpawn,600)
  elseif gameStats.twoTeamsMode then
    -- Preserve the original score position in each of the four courts.
    add(teamsScores.blue,colors.blue,200)
    add(teamsScores.red,colors.red,550)
    add(teamsScores.blue,colors.blue,950)
    add(teamsScores.red,colors.red,1300)
  elseif gameStats.threeTeamsMode or gameStats.teamsMode then
    if gameStats.typeMap == "large4v4" then
      if gameStats.teamsMode then add(teamsLifes[1].yellow,colors.yellow,200) end
      add(teamsLifes[2].red,colors.red,gameStats.teamsMode and 550 or 350)
      add(teamsLifes[3].blue,colors.blue,gameStats.teamsMode and 950 or 850)
      add(teamsLifes[4].green,colors.green,gameStats.teamsMode and 1300 or 1350)
    else
      local count = gameStats.teamsMode and gameStats.typeMap == "large3v3" and 3 or 2
      local positions = gameStats.typeMap == "small" and {0,700} or count == 3 and {200,550,900} or {200,900}
      for i=1,count do
        if getTeamsLifes[i] == nil or getTeamsColors[i] == nil then return end
        add(getTeamsLifes[i],tagColors[getTeamsColors[i]] or "#E3ECE7",positions[i])
      end
    end
  else
    local positions = gameStats.gameMode == "3v3" and {0,700} or gameStats.gameMode == "4v4" and {200,900} or {200,1500}
    add(teamsScores.red,colors.red,positions[1])
    add(teamsScores.blue,colors.blue,positions[2])
  end
  clubhouse.drawScores(entries)
end

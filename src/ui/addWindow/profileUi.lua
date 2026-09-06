local function profileEscape(text)
  return tostring(text):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

function getProfileText(name)
  local language = playerLanguage[name] and playerLanguage[name].tr
  return (language and language.profile) or lang.en.profile
end

function resolveProfileTarget(query)
  if type(query) ~= "string" then return nil, "notFound" end
  local lower = query:lower()
  local candidate, count = nil, 0
  for target in pairs(playerAchievements) do
    if target:lower() == lower then return target end
    if not query:find("#", 1, true) and target:gsub("#%d+$", ""):lower() == lower then
      candidate, count = target, count + 1
    end
  end
  if count == 1 then return candidate end
  return nil, count > 1 and "ambiguous" or "notFound"
end

local function profileArea(id, text, name, x, y, width, height, color, alpha)
  ui.addTextArea(id, text, name, x, y, width, height, color or 0x142B2E,
    color or 0x142B2E, alpha or 0, true)
end

function updateProfileMode(name, index)
  local state = profileState[name]
  if not state or not isOpenProfile[name] or not index or index % 1 ~= 0 or index < 1 or index > 5 then return end
  state.mode = index
  local text = getProfileText(name)
  local sources = { playersNormalMode, playersTwoTeamsMode, playersThreeTeamsMode, playersFourTeamsMode, playersRealMode }
  local updaters = { updateRankingNormalMode, updateRankingTwoTeamsMode, updateRankingThreeTeamsMode, updateRankingFourTeamsMode, updateRankingRealMode }
  local modeNames = { "Normal mode", "2 teams mode", "3 teams mode", "4 teams mode", "Real mode" }
  local stats = sources[index][state.target] or {}
  local matches, wins = stats.matches or 0, stats.wins or 0
  local position = "—"
  updaters[index]()
  if matches > 0 then
    for rank, player in ipairs(rankMode(modeNames[index])) do
      if player.name == state.target then position = "#" .. rank; break end
    end
  end
  profileArea(8705, "<p align='right'><font size='28' color='#DEC18A'>" .. position .. "</font></p>", name, 580, 59, 125, 37)
  profileArea(8706, "<p align='right'><font size='10' color='#A9BCB4'>" .. (matches > 0 and text.rank or text.unranked) .. "</font></p>", name, 540, 98, 165, 20)
  for i, label in ipairs(text.modes) do
    local selected = index == i
    profileArea(8709 + i, "<p align='center'><font size='11' color='" .. (selected and "#E3ECE7" or "#A9BCB4") .. "'><a href='event:profileMode" .. i .. "'>" .. label .. "</a></font></p>",
      name, 94 + (i - 1) * 123, 134, 114, 23, selected and 0x305048 or 0x142B2E, 1)
  end
  local labels = { text.matches, text.wins, text.rate }
  local values = { matches, wins, matches > 0 and (math.floor(wins * 100 / matches + 0.5) .. "%") or "—" }
  for i = 1, 3 do
    profileArea(8714 + i, "<font size='10' color='#A9BCB4'>" .. labels[i] .. "</font><br><font size='25' color='#E3ECE7'>" .. values[i] .. "</font>",
      name, 94 + (i - 1) * 211, 170, 190, 51)
  end
end

function showProfileTrophy(name, index)
  local state = profileState[name]
  if not state or not isOpenProfile[name] or not index or index % 1 ~= 0 or index < 1 or index > 6 then return end
  local trophy = playerAchievements[state.target] and playerAchievements[state.target][index]
  if not trophy then return end
  state.trophy = index
  local text = getProfileText(name)
  local description = playerLanguage[name].tr.msgsTrophies[index]
  if not description or description == "" then description = text.trophy .. " " .. index end
  local quantity = trophy.quantity or 0
  local detail = quantity > 0 and string.format(text.quantity, quantity) or text.locked
  profileArea(8719, "<font size='10' color='#E3ECE7'>" .. profileEscape(description) .. "</font><br><font size='10' color='#A9BCB4'>" .. detail .. "</font>", name, 94, 306, 475, 34)
  ui.removeTextArea(8722, name)
  if state.target == name and quantity > 0 then
    profileArea(8722, "<p align='right'><font size='11' color='#DEC18A'><a href='event:profileEquipTrophy'>" .. text.show .. "</a></font></p>", name, 585, 312, 120, 24)
  end
end

function equipProfileTrophy(name)
  local state = profileState[name]
  if not state or state.target ~= name or not state.trophy then return end
  local trophy = playerAchievements[name] and playerAchievements[name][state.trophy]
  if not trophy or (trophy.quantity or 0) < 1 then return end
  removePlayerTrophy(name)
  closeAllWindows(name)
  playerTrophyImage[name] = tfm.exec.addImage(trophy.image, "$" .. name, -20, -105, nil)
  tfm.exec.playEmote(name, 0)
  removePlayerTrophyImage(name)
end

function profileUI(name, playerTarget)
  if not playerAchievements[playerTarget] then return end
  removeUITrophies(name)
  isOpenProfile[name] = true
  profileState[name] = { target = playerTarget }
  local text = getProfileText(name)
  profileArea(8700, "", name, 70, 35, 660, 330, 0x142B2E, 1)
  profileArea(8701, "", name, 71, 36, 658, 88, 0x1B3739, 1)
  profileArea(8707, "", name, 70, 35, 660, 2, 0xDEC18A, 1)
  profileArea(8702, "<font size='10' color='#DEC18A'>#VOLLEY / " .. text.title .. "</font>", name, 94, 47, 420, 20)
  local nick, tag = playerTarget:match("^(.-)(#%d+)$")
  profileArea(8703, "<font size='21' color='#E3ECE7'>" .. profileEscape(nick or playerTarget) .. "</font><font size='11' color='#A9BCB4'>" .. profileEscape(tag or "") .. "</font>", name, 94, 68, 430, 30)
  local level = USER_PERMISSIONS[playerTarget] or 1
  local role = text.roles[level] or text.roles[1]
  if roomCreator.name == playerTarget then role = "Room Creator · " .. role end
  profileArea(8704, "<font size='10' color='#DEC18A'>" .. role .. "</font>", name, 94, 102, 435, 19)
  profileArea(8708, "<p align='right'><font size='11' color='#E3ECE7'><a href='event:profileClose'>" .. text.close .. " ×</a></font></p>", name, 622, 39, 94, 20)
  local collected = 0
  local ids = { 27, 28, 29, 32, 33, 34 }
  for i = 1, 6 do
    if (playerAchievements[playerTarget][i].quantity or 0) > 0 then collected = collected + 1 end
    ui.addTrophie(ids[i], "trophie" .. i, name, playerTarget, 94 + (i - 1) * 106, 250, 82, 50, 1)
  end
  profileArea(8718, "<font size='12' color='#E3ECE7'>" .. text.trophies .. "</font><font size='10' color='#A9BCB4'>   " .. collected .. "/6</font>", name, 94, 227, 600, 20)
  profileArea(8721, "", name, 94, 222, 611, 1, 0x395753, 1)
  profileArea(8720, "<font size='10' color='#A9BCB4'>" .. text.session .. "</font>", name, 94, 343, 610, 18)
  local index = gameStats.twoTeamsMode and 2 or gameStats.threeTeamsMode and 3 or gameStats.teamsMode and 4 or gameStats.realMode and 5 or 1
  updateProfileMode(name, index)
  showProfileTrophy(name, 1)
end

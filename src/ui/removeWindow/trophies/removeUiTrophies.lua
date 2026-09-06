function removeUITrophies(name)
  isOpenProfile[name] = false

  if profileState[name] then
    for id = 8700, 8722 do
      ui.removeTextArea(id, name)
    end
    profileState[name] = nil
  end

  local ids = { 26, 27, 28, 29, 32, 33, 34 }
  for i = 1, #ids do
    closeWindow(ids[i], name)
  end

  for i = 1, #(playerAchievementsImages[name] or {}) do
    tfm.exec.removeImage(playerAchievementsImages[name][i])
  end

  playerAchievementsImages[name] = {}
end

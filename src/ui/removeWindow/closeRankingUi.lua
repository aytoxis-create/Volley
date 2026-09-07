function closeRankingUI(name)
  if not rankingState[name] and not openRank[name] then return end
  clubhouse.clear(name, "ranking")
  if rankingState[name] then
    for id = 8800, 8929 do ui.removeTextArea(id, name) end
  end
  rankingState[name] = nil
  openRank[name] = false
  clubhouse.restoreLobbyControls(name)
  for i = 9999543, 9999565 do
    ui.removeTextArea(i, name)
  end
end

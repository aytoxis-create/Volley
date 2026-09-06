function ui.addTrophie(id, event, player, playerTarget, x, y, width, height, alpha)
  local index = tonumber(event:sub(8))
  local trophy = playerAchievements[playerTarget] and playerAchievements[playerTarget][index]
  if not trophy then return end
  id = tostring(id)
  local quantity = trophy.quantity or 0
  local border = quantity > 0 and 0x8D805F or 0x395753
  ui.addTextArea(id .. "0", "", player, x, y, width, height, 0x1B3739, border, alpha, true)
  ui.addTextArea(id .. "0000000", "", player, x + 1, y + 1, width - 2, height - 2, 0x1B3739, 0x1B3739, alpha, true)
  if trophy.image then
    table.insert(playerAchievementsImages[player], tfm.exec.addImage(trophy.image, "~" .. id .. "0000000", x + (width - 40) / 2, y + 3, player))
  end
  local color = quantity > 0 and "#DEC18A" or "#A9BCB4"
  ui.addTextArea(id .. "00000", "<p align='right'><font size='10' color='" .. color .. "'><a href='event:" .. event .. "'>×" .. quantity .. "</a></font></p>",
    player, x + width - 27, y + height - 17, 25, 16, 0, 0, 0, true)
  ui.addTextArea(id .. "00000000", "<a href='event:" .. event .. "'><font size='20'><br> <br> </font></a>", player, x, y, width, height, 0, 0, 0, true)
end

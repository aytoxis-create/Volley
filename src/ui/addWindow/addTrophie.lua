function ui.addTrophie(id, event, player, playerTarget, x, y, width, height, alpha)
  local index = tonumber(event:sub(8))
  local trophy = playerAchievements[playerTarget] and playerAchievements[playerTarget][index]
  if not trophy then return end
  id = tostring(id)
  if clubhouse.images[clubhouse.interiors.profile] then alpha = 0 end
  local quantity = trophy.quantity or 0
  local border = quantity > 0 and 0xA37A3D or 0x4C4834
  local background = quantity > 0 and 0x182B27 or 0x0C1C1E
  ui.addTextArea(id .. "0", "", player, x, y, width, height, background, border, alpha, true)
  ui.addTextArea(id .. "0000000", "", player, x + 1, y + 1, width - 2, height - 2, background, background, alpha, true)
  if trophy.image then
    -- Profile thumbnails only: leave the trophy equipped above a player unchanged.
    local scale = 0.8
    local size = 40 * scale
    local lift = (index == 1 or index == 3 or index == 5 or index == 6) and 3 or 0
    table.insert(playerAchievementsImages[player], tfm.exec.addImage(trophy.image, "~" .. id .. "0000000",
      x + (width - size) / 2, y + (height - size) / 2 - lift, player, scale, scale))
  end
  local color = quantity > 0 and "#DEC18A" or "#8F9588"
  ui.addTextArea(id .. "00000", "<p align='right'><font size='10' color='" .. color .. "'><a href='event:" .. event .. "'>×" .. quantity .. "</a></font></p>",
    player, x + width - 32, y + height - 23, 25, 16, 0, 0, 0, true)
  ui.addTextArea(id .. "00000000", "<a href='event:" .. event .. "'><font size='20'><br> <br> </font></a>", player, x, y, width, height, 0, 0, 0, true)
end

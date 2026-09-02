function selectUiTabs(name, active)
  local mapsTab = active == "maps" and "<j>Maps<n>" or "<a href='event:selectMap'>Maps</a>"
  local ballsTab = active == "balls" and "<j>Balls<n>" or "<a href='event:selectBall'>Balls</a>"

  ui.addTextArea(99999999999,
    "<p align='center'><font size='13px'>" .. mapsTab .. "  |  " .. ballsTab .. "", name,
    355, 88, 190, 20, 0x142b2e, 0x2d5a61, 0, true)
end

function selectBallPointersNavigation(name, page, maxPage)
  local str = ""
  for i = 1, maxPage do
    if page == i then
      str = "" .. str .. " <j>•<n>"
    else
      str = "" .. str .. " <a href='event:nextSelectBall" .. i .. "'>•</a>"
    end
  end

  ui.addTextArea(9999999999, "<p align='center'><font size='18px'>" .. str .. "", name, 347, 300, 200, 20, 0x161616,
    0x161616, 0, true)
end

function selectBallUI(name)
  removeSelectUI(name)
  local maxPage = getMaxPageMap(balls)
  local page = selectBallPage[name]
  local userLevel = USER_PERMISSIONS[name] or 1

  for i = 1, 5 do
    local index = i + ((page - 1) * 5)
    local ball = balls[index]

    if ball ~= nil then
      local textSelect = "<a href='event:setball" .. index .. "'>Select ball</a>"

      if gameStats.customBall and index == gameStats.customBallId then
        textSelect = "<j>Selected ball<n>"
      elseif userLevel == 1 then
        textSelect = "<n2>Select ball<n>"
      end

      ui.addTextArea("" .. tostring(99999) .. "" .. tostring(i) .. "", "", name, (142 + ((i - 1) * 125)), 115, 110, 140,
        0x142b2e, 0x8a583c, 1, true)
      ui.addTextArea("" .. tostring(999999) .. "" .. tostring(i) .. "", "", name, (147 + ((i - 1) * 125)), 120, 100, 43,
        0x142b2e, 0x2d5a61, 1, true)
      ui.addTextArea("" .. tostring(9999999) .. "" .. tostring(i) .. "",
        "<p align='center'><font size='11px'>" .. ball.name .. "", name, (147 + ((i - 1) * 125)), 170, 100, 40,
        0x142b2e, 0x2d5a61, 0, true)
      ui.addTextArea("" .. tostring(99999999) .. "" .. tostring(i) .. "",
        "<p align='center'><font size='12px'>" .. textSelect .. "", name, (147 + ((i - 1) * 125)), 225, 100, 20,
        0x142b2e, 0x2d5a61, 1, true)

      if ball.image ~= '' then
        -- Center the preview inside the 100x43 frame (skins are 40x40, legacy ones 30x30)
        local size = ball.size or 40
        local imgX = 147 + math.floor((100 - size) / 2) + ((i - 1) * 125)
        local imgY = 120 + math.floor((43 - size) / 2) + 2
        table.insert(selectMapImages[name],
          tfm.exec.addImage(ball.image, "~999999" .. i .. "", imgX, imgY, name))
      end
    end
  end

  selectBallPointersNavigation(name, page, maxPage)
  selectUiTabs(name, "balls")

  if page == 1 then
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1, "<n2>" .. playerLanguage[name].tr.previousMessage .. "</n>")
  else
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1,
      "<a href='event:prevSelectBall" .. tostring(page - 1) .. "'>" .. playerLanguage[name].tr.previousMessage .. "</a>")
  end

  if page >= maxPage then
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1, "<n2>" .. playerLanguage[name].tr.nextMessage .. "</n>")
  else
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1,
      "<a href='event:nextSelectBall" .. tostring(page + 1) .. "'>" .. playerLanguage[name].tr.nextMessage .. "</a>")
  end
end

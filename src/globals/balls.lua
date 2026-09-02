local balls = {
  [1] = { id = 6, isImage = false, image = '1a063033815.png', name = 'Default ball' },
  [2] = { id = 608, isImage = false, image = '1a063037e69.png', name = 'Futuristic ball' },
  [3] = { id = 611, isImage = false, image = '1a063034f85.png', name = 'Dino egg ball' },
  [4] = { id = 612, isImage = false, image = '1a06302f1c3.png', name = 'Basketball' },
  [5] = { id = 616, isImage = false, image = '1a0630366f8.png', name = 'Earth ball' },
  [6] = { id = 619, isImage = false, image = '1a06303ad4e.png', name = 'Poisoned apple ball' },
  [7] = { id = 621, isImage = false, image = '1a06303c4c1.png', name = 'Snow globe ball' },
  [8] = { id = 626, isImage = false, image = '1a063030932.png', name = 'Bubble ball' },
  [9] = { id = 630, isImage = false, image = '1a0630395db.png', name = 'Moon ball' },
  [10] = { id = 635, isImage = false, image = '1a0630320a2.png', name = 'Crystal ball' },
  [11] = { id = 6, isImage = true, image = '18fd18e2334.png', name = 'White Volley ball' },
  [12] = { id = 6, isImage = true, image = '18fd18e5dc6.png', name = 'Original Volley ball' },
  [13] = { id = 604, isImage = true, image = '197d9275c53.png', name = 'Morocco ball' },
  [14] = { id = 604, isImage = false, image = '1a06303dc32.png', name = 'Soccer ball' },
  [15] = { id = 6, isImage = true, image = '19a63e144c6.png', name = 'Uruguay ball' }
  -- [99] = {
  --   id = 6,
  --   isImage = no,
  --   image = '',
  --   name = 'Custom ball'
  -- }
}

-- Attaches the ball skin image to a spawned ball object.
-- Old custom skins (isImage = true) are 30x30 px, newer stock skins are 40x40 px.
function addBallSkin(objId)
  local ball = balls[gameStats.customBallId]

  if not objId or ball.image == '' then return end

  local offset = ball.isImage and -15 or -20
  tfm.exec.addImage(ball.image, "#" .. objId, offset, offset, nil, 1, 1, _, 10)
end

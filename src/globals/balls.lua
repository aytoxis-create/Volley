local balls = {
  [1] = { id = 6, isImage = false, image = '1a063033815.png', name = 'Default ball' },
  [2] = { id = 608, isImage = false, image = '1a063037e69.png', name = 'Futuristic ball' },
  [3] = { id = 611, isImage = false, image = '1a063034f85.png', name = 'Dino egg ball' },
  [4] = { id = 612, isImage = false, image = '1a06302f1c3.png', name = 'Basketball' },
  [5] = { id = 616, isImage = false, image = '1a0630366f8.png', name = 'Earth ball', skinScale = 0.94 },
  [6] = { id = 619, isImage = false, image = '1a06303ad4e.png', name = 'Poisoned apple ball', skinScale = 0.90 },
  [7] = { id = 621, isImage = false, image = '1a06303c4c1.png', name = 'Snow globe ball', skinScale = 0.90 },
  [8] = { id = 626, isImage = false, image = '1a063030932.png', name = 'Bubble ball' },
  [9] = { id = 630, isImage = false, image = '1a0630395db.png', name = 'Moon ball' },
  [10] = { id = 635, isImage = false, image = '1a0630320a2.png', name = 'Crystal ball', skinScale = 0.94 },
  [11] = { id = 6, isImage = true, image = '18fd18e2334.png', name = 'White Volley ball', size = 30, category = 'collection' },
  [12] = { id = 6, isImage = true, image = '18fd18e5dc6.png', name = 'Original Volley ball', size = 30, category = 'collection', categoryOrder = 0 },
  [13] = { id = 604, isImage = true, image = 'img@1a080202d73', name = 'Morocco ball', size = 30, category = 'worldcup', skinScale = 1.07 },
  [14] = { id = 604, isImage = false, image = '1a06303dc32.png', name = 'Soccer ball' },
  [15] = { id = 6, isImage = true, image = 'img@1a08020e8dd', name = 'Uruguay ball', size = 30, category = 'worldcup', skinScale = 1.07 },
  [16] = { id = 6, isImage = true, image = 'img@1a0802163d6', name = 'Lagon Volley ball', size = 30, category = 'collection', skinScale = 1.07 },
  [17] = { id = 6, isImage = true, image = 'img@1a080213157', name = 'Corail Volley ball', size = 30, category = 'collection', skinScale = 1.07 },
  [18] = { id = 6, isImage = true, image = 'img@1a08021a21f', name = 'Royal Volley ball', size = 30, category = 'collection', skinScale = 1.07 }
  -- [99] = {
  --   id = 6,
  --   isImage = no,
  --   image = '',
  --   name = 'Custom ball'
  -- }
}

-- Attaches the ball skin image to a spawned ball object.
-- size describes the source canvas; skinScale adjusts its in-game appearance.
function addBallSkin(objId)
  local ball = balls[gameStats.customBallId]

  if not objId or ball.image == '' then return end

  local scale = ball.skinScale or 1
  local offset = -(ball.size or 40) * scale / 2
  tfm.exec.addImage(ball.image, "#" .. objId, offset, offset, nil, scale, scale, _, 10)
end

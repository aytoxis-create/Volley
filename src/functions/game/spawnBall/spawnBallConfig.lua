function spawnBallConfig(spawnBalls, x)
  local customBallId = 6
  local ballPlaces = spawnBallsOnSpecificPlaces(spawnBalls, x)

  -- print("Ball places:")
  -- print(ballPlaces)

  if gameStats.customBall then
    customBallId = balls[gameStats.customBallId].id
  end

  ball_id = tfm.exec.addShamanObject(customBallId, ballPlaces[1].x, ballPlaces[1].y, 0, 0, -5, true)

  if gameStats.customBall then
    addBallSkin(ball_id)
  end

  if gameStats.twoBalls or gameStats.threeBalls then
    ball_id2 = tfm.exec.addShamanObject(customBallId, ballPlaces[2].x, ballPlaces[2].y, 0, 0, -5, true)

    if gameStats.customBall then
      addBallSkin(ball_id2)
    end
    ballOnGame2 = true
  end

  if gameStats.threeBalls then
    ball_id3 = tfm.exec.addShamanObject(customBallId, ballPlaces[3].x, ballPlaces[3].y, 0, 0, -5, true)

    if gameStats.customBall then
      addBallSkin(ball_id3)
    end
    ballOnGame3 = true
  end

  ballOnGame = true
  updateTwoBallOnGame()
end

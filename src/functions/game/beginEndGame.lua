-- Stop pending gameplay immediately, including callbacks due in this eventLoop.
function beginEndGame()
  if mode == "endGame" then return end
  clearRoundTimers()
  gameStats.canTransform = false
  ballOnGame, ballOnGame2, ballOnGame3 = false, false, false
  updateTwoBallOnGame()
  mode = "endGame"
  gameTimeEnd = os.time() + 5000
end

-- Timers are iterated through a snapshot: callbacks may cancel or create timers.
-- IDs are never reused, so an old UI/player handle cannot cancel a newer timer.
local timerState = { active = {}, nextId = 0, round = 0 }

function addTimer(callback, ms, loops, label, ...)
  timerState.nextId = timerState.nextId + 1
  local id = timerState.nextId
  timerState.active[id] = {
    callback = callback, time = ms, loops = loops or 1, label = label,
    arguments = { n = select('#', ...), ... }, currentTime = 0,
    currentLoop = 0, isPaused = false
  }
  return id
end

function addRoundTimer(callback, ms, loops, label, ...)
  local id = addTimer(callback, ms, loops, label, ...)
  timerState.active[id].round = timerState.round
  return id
end

function getTimerId(label)
  local first
  for id, timer in pairs(timerState.active) do
    if timer.label == label and (not first or id < first) then first = id end
  end
  return first
end

function pauseTimer(id)
  if type(id) == 'string' then id = getTimerId(id) end
  local timer = timerState.active[id]
  if not timer then return false end
  timer.isPaused = true
  return true
end

function resumeTimer(id)
  if type(id) == 'string' then id = getTimerId(id) end
  local timer = timerState.active[id]
  if not timer or not timer.isPaused then return false end
  timer.isPaused = false
  return true
end

function removeTimer(id)
  if type(id) == 'string' then
    local removed = false
    for key, timer in pairs(timerState.active) do
      if timer.label == id then timerState.active[key] = nil; removed = true end
    end
    return removed
  end
  if id == nil or not timerState.active[id] then return false end
  timerState.active[id] = nil
  return true
end

function clearRoundTimers()
  timerState.round = timerState.round + 1
  for id, timer in pairs(timerState.active) do
    if timer.round ~= nil then timerState.active[id] = nil end
  end
end

function clearTimers()
  timerState.round = timerState.round + 1
  timerState.active = {}
end

function timersLoop()
  local pending = {}
  for id in pairs(timerState.active) do pending[#pending + 1] = id end
  table.sort(pending)
  for _, id in ipairs(pending) do
    local timer = timerState.active[id]
    if timer and not timer.isPaused then
      timer.currentTime = timer.currentTime + 500
      if timer.currentTime >= timer.time then
        timer.currentTime = 0
        timer.currentLoop = timer.currentLoop + 1
        local complete = timer.loops > 0 and timer.currentLoop >= timer.loops
        if complete then timerState.active[id] = nil end
        if timer.callback then
          timer.callback(timer.currentLoop, (table.unpack or unpack)(timer.arguments, 1, timer.arguments.n))
        end
        if complete and eventTimerComplete then eventTimerComplete(id, timer.label) end
      end
    end
  end
end

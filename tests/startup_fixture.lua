
mock = { calls = {}, areas = {}, now = 1788600000000, nextId = 0 }
local function record(api, ...)
  table.insert(mock.calls, { api = api, args = {...} })
end
local function noop(api)
  return function(...) record(api, ...) end
end
tfm = { exec = {}, get = {room = {name = "*#volley0smoke", language = "en",
  playerList = {}, objectList = {}, maxPlayers = 16, isTribeHouse = false,
  xmlMapInfo = {xml = fixtureXML}, currentMap = "@smoke"}} }
ui = {}
system = {}
for _, name in ipairs({"disableAfkDeath", "disableAllShamanSkills", "disableAutoNewGame",
  "disableAutoScore", "disableAutoShaman", "disableAutoTimeLeft", "disableMortCommand",
  "disablePhysicalConsumables", "setGameTime", "setNameColor", "playEmote", "removeImage",
  "removePhysicObject", "setRoomPassword", "setPlayerSync", "addPhysicObject"}) do
  tfm.exec[name] = noop("tfm.exec." .. name)
end
tfm.exec.chatMessage = noop("tfm.exec.chatMessage")
tfm.exec.newGame = function(map) record("tfm.exec.newGame", map); mock.pendingMap = map end
tfm.exec.setRoomMaxPlayers = function(n) tfm.get.room.maxPlayers = n end
tfm.exec.addImage = function(...) mock.nextId=mock.nextId+1; return mock.nextId end
tfm.exec.addShamanObject = function(kind,x,y)
  mock.nextId=mock.nextId+1
  tfm.get.room.objectList[mock.nextId] = {x=x,y=y,vx=0,vy=0,type=kind}
  return mock.nextId
end
tfm.exec.removeObject = function(id) tfm.get.room.objectList[id] = nil end
tfm.exec.killPlayer = function(name)
  record("tfm.exec.killPlayer",name)
  if tfm.get.room.playerList[name] then tfm.get.room.playerList[name].isDead=true end
end
tfm.exec.respawnPlayer = function(name)
  record("tfm.exec.respawnPlayer",name)
  if tfm.get.room.playerList[name] then tfm.get.room.playerList[name].isDead=false end
end
-- Kick is asynchronous in the host: record it and leave event delivery to the test.
tfm.exec.kickPlayer = noop("tfm.exec.kickPlayer")
tfm.exec.movePlayer = noop("tfm.exec.movePlayer")
tfm.exec.getPlayerSync = function() return next(tfm.get.room.playerList) end
tfm.exec.setPlayerScore = function(name,score,add)
  local p = tfm.get.room.playerList[name]
  if p then p.score = (add and p.score or 0) + score end
end
ui.addTextArea = function(id,text,target,...)
  record("ui.addTextArea",id,text,target,...)
  mock.areas[tostring(id)..":"..(target or "*")] = text
end
ui.updateTextArea = function(id,text,target)
  record("ui.updateTextArea",id,text,target)
  mock.areas[tostring(id)..":"..(target or "*")] = text
end
ui.removeTextArea = function(id,target)
  record("ui.removeTextArea",id,target)
  if target then mock.areas[tostring(id)..":"..target] = nil
  else
    for key in pairs(mock.areas) do
      if key:sub(1,#tostring(id)+1) == tostring(id)..":" then mock.areas[key] = nil end
    end
  end
end
ui.addPopup = noop("ui.addPopup")
ui.setMapName = noop("ui.setMapName")
system.bindKeyboard = noop("system.bindKeyboard")
system.disableChatCommandDisplay = noop("system.disableChatCommandDisplay")
os.time = function() return mock.now end
print = noop("print")
function mockPlayer(name, registrationDate)
  tfm.get.room.playerList[name] = {id=1,x=400,y=300,vx=0,vy=0,
    averageLatency=30,ping=30,registrationDate=registrationDate or 0,
    tribeName="",score=0,isDead=false,isVampire=false}
end
function mockJoin(name, registrationDate)
  mockPlayer(name, registrationDate)
  eventNewPlayer(name)
end
function mockLeave(name)
  tfm.get.room.playerList[name] = nil
  eventPlayerLeft(name)
end
function assertNoGetAdmin()
  for _, call in ipairs(mock.calls) do
    if call.api == "ui.addTextArea" or call.api == "ui.updateTextArea" then
      assert(not tostring(call.args[2]):find("getAdmin",1,true), "GET admin button was rendered")
    end
  end
end
function creatorAnnouncements()
  local count=0
  for _, call in ipairs(mock.calls) do
    if call.api == "tfm.exec.chatMessage" and tostring(call.args[1]):find("is the Room Creator",1,true) then count=count+1 end
  end
  return count
end

table.unpack = table.unpack or unpack

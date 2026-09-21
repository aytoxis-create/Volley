"""Lua 5.1 regressions for timer ownership and match/lobby transitions.

Run: python tests/timers.py [volley.lua]. Requires lupa; host APIs are mocked.
"""
from pathlib import Path
import sys
import unittest
from lupa.lua51 import LuaRuntime

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
SOURCE = (Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "volley.lua").read_text(encoding="utf-8-sig")

def room():
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.globals().fixtureXML = (HERE / "startup_fixture.xml").read_text()
    lua.execute((HERE / "startup_fixture.lua").read_text())
    lua.globals().mockPlayer("Creator#0000", 0)
    lua.execute(SOURCE + '''
function prepareMode(label)
  globalSettings.mode=label;init();eventNewGame()
  for _,n in ipairs({'R1','R2','B1','B2','Y1','G1'}) do mockJoin(n,0) end
  playersRed[1].name='R1';playersBlue[1].name='B1'
  playerInGame.R1=true;playerInGame.B1=true
  if gameStats.twoTeamsMode or gameStats.realMode then
    playersRed[2].name='R2';playersBlue[2].name='B2'
    playerInGame.R2=true;playerInGame.B2=true
  end
  if gameStats.teamsMode then playersYellow[1].name='Y1';playerInGame.Y1=true end
  if gameStats.teamsMode or gameStats.threeTeamsMode then playersGreen[1].name='G1';playerInGame.G1=true end
  initGame=os.time()-3500 -- skip the exact zero second
end
function state() return mode end
function tick(n)
  for i=1,n do mock.now=mock.now+500;eventLoop(0,300000) end
end
function deliverMap() tfm.get.room.objectList={};eventNewGame() end
function skipRulesDeadline() rulesTimer=os.time()-3500 end
function skipEndDeadline() gameTimeEnd=os.time()-3500 end
function missingBall()
  ballsId[1]=999999;ballOnGame=true;ballOnGameTwoBalls[1]=true
  verifyIsPoint();tick(6)
end
function assertLobby()
  assert(mode=='startGame',mode)
  assert(not ballOnGame and not ballOnGame2 and not ballOnGame3)
  assert(teamsScores.red==0 and teamsScores.blue==0)
end
''')
    lua.globals().eventNewGame()
    return lua

class Timers(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime()
        self.lua.execute((ROOT / "src/timer.lua").read_text())

    def test_duplicate_labels_cancel_all_and_ignore_completed(self):
        self.lua.execute('''
          count=0
          addTimer(function() count=count+1 end,500,1,'deadTimer');timersLoop()
          addTimer(function() count=count+1 end,500,1,'deadTimer')
          addTimer(function() count=count+1 end,500,1,'deadTimer')
          assert(removeTimer('deadTimer'));timersLoop();assert(count==1)
          assert(not removeTimer('deadTimer'))
        ''')

    def test_clear_cancels_active_and_does_not_reuse_handles(self):
        self.lua.execute('''
          count=0;old=addTimer(function() error('stale') end,500,0)
          clearTimers();new=addTimer(function() count=count+1 end,500,1)
          assert(old~=new and not removeTimer(old));timersLoop();assert(count==1)
        ''')

    def test_round_clear_preserves_session_and_new_callbacks_wait(self):
        self.lua.execute('''
          session=0;fresh=0
          addRoundTimer(function()
            clearRoundTimers()
            addRoundTimer(function() fresh=fresh+1 end,500,1)
          end,500,1)
          addRoundTimer(function() error('cancelled same tick') end,500,1)
          addTimer(function() session=session+1 end,500,1)
          timersLoop();assert(session==1 and fresh==0)
          timersLoop();assert(fresh==1)
        ''')

    def test_pause_repeat_and_nil_arguments(self):
        self.lua.execute('''
          count=0
          id=addTimer(function(loop,a,b,c)
            assert(a=='a' and b==nil and c=='c');count=count+1;assert(loop==count)
          end,1000,2,'repeat','a',nil,'c')
          timersLoop();assert(pauseTimer(id));timersLoop();assert(count==0)
          assert(resumeTimer(id));timersLoop();assert(count==1)
          timersLoop();timersLoop();timersLoop();assert(count==2)
        ''')

class Transitions(unittest.TestCase):
    def test_delayed_deadlines_and_command_return_all_modes(self):
        for label in ['Normal mode','2 teams mode','3 teams mode','4 teams mode','Real mode']:
            with self.subTest(mode=label):
                lua=room()
                for _ in range(2):
                    lua.globals().prepareMode(label)
                    lua.globals().eventLoop(0,300000)
                    if label=='Real mode':
                        self.assertEqual(lua.globals().state(),'showRules')
                        lua.globals().skipRulesDeadline();lua.globals().eventLoop(0,300000)
                    self.assertEqual(lua.globals().state(),'gameStart')
                    lua.globals().deliverMap();lua.globals().tick(16)
                    lua.execute('''
                      stale=0;session=0
                      addRoundTimer(function() stale=stale+1 end,500,0)
                      addTimer(function() session=session+1 end,500,1)
                      eventPlayerDied('R1')
                      eventChatCommand('Creator#0000','lobby')
                    ''')
                    self.assertEqual(lua.globals().state(),'endGame')
                    lua.globals().skipEndDeadline();lua.globals().eventLoop(0,300000)
                    lua.globals().deliverMap();lua.globals().tick(12)
                    lua.globals().assertLobby()
                    lua.execute('assert(stale==0 and session==1)')

    def test_direct_reset_invalidates_pending_gameplay(self):
        lua=room()
        lua.execute('''
          addRoundTimer(function() error('old respawn') end,500,1,'deadTimer')
          addRoundTimer(function() error('old map load') end,500,1)
          init();tick(12)
        ''')
        lua.globals().assertLobby()

    def test_match_end_inside_timer_cancels_other_due_actions(self):
        lua=room()
        lua.execute('''
          addRoundTimer(function() beginEndGame() end,500,1)
          addRoundTimer(function() error('respawn after victory') end,500,1)
          timersLoop();assert(state()=='endGame')
        ''')

    def test_missing_ball_during_transition(self):
        for label in ['Normal mode','2 teams mode']:
            with self.subTest(mode=label):
                lua=room();lua.globals().prepareMode(label)
                lua.globals().eventLoop(0,300000)
                lua.globals().deliverMap();lua.globals().tick(16)
                lua.globals().missingBall()

if __name__ == '__main__':
    unittest.main(argv=[sys.argv[0]], verbosity=2)

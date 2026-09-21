"""Compile and start a built artifact in Lua 5.1 with mocked Transformice APIs.

Install the test dependency with: python -m pip install lupa
This does not simulate client rendering, physics, or asynchronous network events.
"""
from pathlib import Path
import sys
from lupa.lua51 import LuaRuntime

fixtures = Path(__file__).resolve().parent
artifact = Path(sys.argv[1]) if len(sys.argv) > 1 else fixtures.parent / "volley.lua"
source = artifact.read_text(encoding="utf-8-sig")
if not source.strip():
    raise AssertionError("Empty Lua artifact")
for populated in (False, True):
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.globals().fixtureXML = (fixtures / "startup_fixture.xml").read_text(encoding="utf8")
    lua.execute((fixtures / "startup_fixture.lua").read_text(encoding="utf8"))
    if populated:
        lua.globals().mockPlayer("Creator#0000", 0)
    lua.execute(source, name=str(artifact))
    assert lua.globals().mock.pendingMap is not None, "Initialization did not request a map"
    for event in ("eventNewGame", "eventNewPlayer", "eventPlayerLeft", "eventLoop", "eventChatCommand"):
        assert lua.eval("type")(lua.globals()[event]) == "function", f"Missing {event}"
    lua.globals().eventNewGame()
print("Lua 5.1 compilation and empty/populated room startup passed.")

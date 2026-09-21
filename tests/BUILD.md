# Build validation

`npm run build` assembles a readable script; `npm run minify` assembles then minifies
the complete script. Both parse the complete chunk before replacing `volley.lua`.
Failed reads, parse errors and empty output leave the previous artifact intact.
`npm run watch` rebuilds after source changes and continues watching after errors.

Run `npm run test:build` for repeated-build determinism and failed-build preservation.
The tests use an isolated temporary copy of the source tree.

For actual Lua 5.1 compilation (including the local-variable limit) and startup:

```sh
python -m pip install lupa
npm run build
npm run test:startup
npm run minify
npm run test:startup
```

The default build checks syntax through luamin; it does not require Python.
Run the startup checks before distributing either artifact. They mock Transformice
APIs and cover both empty and populated rooms, not physics or live rendering.

Run `npm run test:timers` after a readable build for Lua 5.1 timer and transition
regressions across all five modes. The test appends accessors to the shared chunk,
so use `npm run build` first (minification renames the locals it inspects).

Gameplay and delayed lobby setup use `addRoundTimer`, canceled at match start,
match end and lobby reset. UI/command cooldowns use `addTimer` and retain their
existing owners. `removeTimer(label)` cancels every active timer with that label;
IDs are never reused. New timers scheduled inside a callback run no earlier than
the next tick. The existing 500 ms timer tick cadence is retained.

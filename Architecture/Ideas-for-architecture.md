always audit plans currently given and in the future. review the impact and performance hit and the time it takes for development.

The original 7-item list here is resolved: (1) color palette not persisting across
reload/relogin, (2) kill/item objective counts not updating, (3) no menu explanation of
auto-progress/catchup mode, (4) "Stop recording"/"Save as a route" cluttering the menu,
(5) Map button doing nothing, (6) class icon instead of a red "?", (7) Panel default
position/centered intro/changelog notice. Items 1-3 and 5-7 were already fixed on `master`
before this audit (commits 33c70fa, da6cfee); item 4 was implemented 2026-09-20 (recording
now defaults off, moved into the "Content & Import" submenu in v1.5.5). All 7 were confirmed
working as intended in an in-game pass on Forever (2026-09-20).
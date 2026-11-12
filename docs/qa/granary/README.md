# Scene05 — actual Godot4.7.2 review

Native1280×720 GL Compatibility frames, existing F6 scene. [Beginning](begin.png) ~0.6s, [middle](middle.png) ~1.8s, [end](end.png) ~3.35s; [fair](fair.png) and [silence](silence.png) at ~1.8s. Full native passes for each outcome and solo, pause/skip and actual fair Event→Scene05→Table completed. Fair effect applied once: gold50→38, HP bonus+16 and ration fact; state unchanged during travel. Existing full GUT292/292,72,455 assertions,19 pre-existing warnings; travel24/24,1,003 assertions. No new QA framework.

Combined production-route fixture retains baseline shutdown diagnostics (6 ObjectDB instances on final run; earlier combined route8 ObjectDB /1 RefCounted), also present in earlier travel fixtures. No script/load/parse/shader/assertion failures in final native pass. Do not claim global leak-free shutdown. Final-head required CI and user artistic acceptance remain separate gates; do not auto-merge.

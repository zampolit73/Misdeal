extends SceneTree
const P := preload("res://scripts/memory/memory_profile.gd")
func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	assert(args.size()==2)
	var profile := P.new()
	if args[0]=="write":
		profile.path=args[1]
		profile.unlocked.assign(["SG01","SG13"])
		assert(profile.save_profile())
	else:
		profile.open_profile(args[1])
		assert(profile.unlocked==["SG01","SG13"])
		profile.begin_run()
		assert(profile.unlocked.size()==2)
	print("A1V2_RESTART_PASS: "+args[0])
	quit()

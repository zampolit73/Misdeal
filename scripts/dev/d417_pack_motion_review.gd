extends SceneTree

# Portable native-frame review. No gameplay assets are edited by this export.
func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].is_absolute_path():
		quit(1)
		return
	var files := DirAccess.get_files_at(args[0])
	files.sort()
	var frames: Array[String] = []
	for filename in files:
		if not filename.ends_with(".png"):
			continue
		var image := Image.load_from_file(args[0].path_join(filename))
		image.resize(640, 360, Image.INTERPOLATE_LANCZOS)
		frames.append("data:image/webp;base64," + Marshalls.raw_to_base64(image.save_webp_to_buffer(true, 0.72)))
	var times = JSON.parse_string(FileAccess.get_file_as_string(args[0].path_join("timings.json")))
	var page := """<!doctype html><html lang="ru"><meta charset="utf-8"><title>Misdeal — запись анимаций интерфейса</title><style>body{margin:30px;background:#100d10;color:#dfc398;font:18px Georgia}main{max-width:1000px;margin:auto}img{width:100%;border:1px solid #8c623b}button{padding:10px 25px;background:#551e1a;color:#f1d8ad;border:1px solid #bd915e;cursor:pointer}p{line-height:1.5;font-size:16px}</style><main><h2>Misdeal — анимации настоящего интерфейса</h2><p>Запись кадров Godot: наведение карты → нажатие кнопки → досье → расклад → описание карты. Превью уменьшено до640×360; интервалы взяты из записи. Игровая логика и арты не воспроизводятся браузером.</p><img id="frame"><p><button id="play">Пауза</button> <span id="counter"></span></p></main><script>const frames=FRAMES_DATA,times=TIMES_DATA;let i=0,playing=true;const pic=document.querySelector('#frame'),counter=document.querySelector('#counter');frames.forEach(src=>{const p=new Image();p.src=src});document.querySelector('#play').onclick=e=>{playing=!playing;e.target.textContent=playing?'Пауза':'Продолжить'};function tick(){pic.src=frames[i];counter.textContent=(i+1)+' / '+frames.length;const delay=i+1<times.length?Math.max(30,times[i+1]-times[i]):650;if(playing)i=(i+1)%frames.length;setTimeout(tick,delay)}tick();</script></html>"""
	page = page.replace("FRAMES_DATA", JSON.stringify(frames)).replace("TIMES_DATA", JSON.stringify(times))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://docs/qa/d417"))
	var file := FileAccess.open("res://docs/qa/d417/motion-preview.html", FileAccess.WRITE)
	file.store_string(page)
	file.close()
	print("D417_REVIEW_EXPORT_PASS: ", frames.size(), " native frames embedded")
	quit()

extends SceneTree

# Pack either the legacy authored selections or a fully approved Echo of Siege set.
# Once manifest.approved_sources is set, NEVER silently fall back to old option N.
func _initialize() -> void:
    var manifest: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://assets/pixel/events/final_five/manifest.json"))
    assert(manifest is Dictionary, "Missing final_five manifest")
    if not manifest is Dictionary:
        quit(1)
        return
    var selection: Dictionary = manifest.get("selection", {})
    var approved_sources: Dictionary = manifest.get("approved_sources", {})
    var event_sources: Dictionary = manifest.get("event_sources", {})
    var event_only: bool = OS.get_cmdline_user_args().has("--event-only")
    for id in selection:
        var event_id: String = str(id)
        var base: String = "res://assets/pixel/events/final_five/" + event_id + "/"
        var source_path: String = "res://assets/pixel/events/final_five/sources/" + event_id + "/option_" + str(int(selection[id])) + ".png"
        if approved_sources.has(event_id):
            source_path = "res://assets/pixel/events/final_five/sources/echo_siege_approved/" + event_id + "/approved_source.png"
        if not FileAccess.file_exists(source_path):
            push_error("Missing approved or legacy image: " + source_path)
            quit(1)
            return
        var source: Image = Image.new()
        source.load_png_from_buffer(FileAccess.get_file_as_bytes(source_path))
        if source == null or source.is_empty():
            push_error("Cannot decode final_five image: " + source_path)
            quit(1)
            return
        DirAccess.make_dir_recursive_absolute(base)
        for spec in [["card", 448, 274], ["backdrop", 1280, 720], ["event", 448, 274]]:
            if spec[0] == "card" and (event_only or event_sources.has(event_id)): continue
            if spec[0] == "event" and not event_sources.has(event_id): continue
            var selected_source: Image = source
            if spec[0] != "card" and event_sources.has(event_id):
                var event_path: String = "res://assets/pixel/events/final_five/sources/event_choice_v1/"+event_id+"/source.png"
                assert(FileAccess.get_sha256(event_path) == event_sources[event_id], "Event source hash mismatch")
                selected_source = Image.new()
                assert(selected_source.load_png_from_buffer(FileAccess.get_file_as_bytes(event_path)) == OK)
            var fitted: Image = selected_source.duplicate() as Image
            var scale: float = minf(float(spec[1]) / selected_source.get_width(), float(spec[2]) / selected_source.get_height())
            fitted.resize(roundi(selected_source.get_width() * scale), roundi(selected_source.get_height() * scale), Image.INTERPOLATE_LANCZOS)
            var canvas: Image = Image.create(spec[1], spec[2], false, Image.FORMAT_RGB8)
            canvas.fill(Color("100e0e"))
            canvas.blit_rect(fitted, Rect2i(Vector2i.ZERO, fitted.get_size()), (canvas.get_size() - fitted.get_size()) / 2)
            var result: Error = canvas.save_webp(base + spec[0] + ".webp", false)
            if result != OK:
                push_error("Failed to write " + base + spec[0] + ".webp")
                quit(1)
                return
            manifest.files[event_id+"\\"+str(spec[0])+".webp"] = FileAccess.get_sha256(base+str(spec[0])+".webp")
    var output := FileAccess.open("res://assets/pixel/events/final_five/manifest.json",FileAccess.WRITE)
    output.store_string(JSON.stringify(manifest,"    "))
    quit()

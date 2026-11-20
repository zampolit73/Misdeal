extends SceneTree
## Offline D420 V2 assembly. Start from the runtime atlas bytes in PR #90.
## All additions are samples of the same character's already authored prop.

const DIR := "res://assets/pixel/units/enemy_visual_polish/"
const CELL := Rect2i(0, 0, 96, 96)
const REPAIRS := {
	"lantern_bearer": ["walk_0-5"],
	"grave_bellkeeper": ["attack_4", "attack_5"],
	"bone_archer": ["hit_0", "hit_1", "hit_2"],
	"drowned_ferryman": ["attack_4"],
	"bone_bailiff": ["hit_0", "hit_1"],
}

func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var source := args[0] if args.size() > 0 else DIR
	var destination := args[1] if args.size() > 1 else DIR
	var manifest: Array = JSON.parse_string(FileAccess.get_file_as_string(source.path_join("manifest.json")))
	for entry: Dictionary in manifest:
		var role: String = entry.role
		if not REPAIRS.has(role):
			continue
		if entry.has("v2_cells"):
			push_error("Provide original PR #90 atlases before reapplying: "+role)
			quit(1)
			return
		var bytes := Marshalls.base64_to_raw(FileAccess.get_file_as_string(source.path_join(role+".webp.b64")).strip_edges())
		var atlas := Image.new()
		assert(atlas.load_webp_from_buffer(bytes) == OK)
		atlas.convert(Image.FORMAT_RGBA8)
		match role:
			"lantern_bearer":
				for column in range(6):
					var pose := _cel(atlas,1,column)
					pose.flip_x()
					_write(atlas,1,column,pose)
			"grave_bellkeeper":
				var swinging := _cel(atlas,2,2).get_region(Rect2i(73,29,19,24))
				_restore(atlas,2,4,swinging,Vector2i(75,32))
				var resting := _cel(atlas,2,0).get_region(Rect2i(8,36,19,28))
				_restore(atlas,2,5,resting,Vector2i(16,40))
			"drowned_ferryman":
				var lantern := _cel(atlas,2,5).get_region(Rect2i(55,38,14,37))
				_restore(atlas,2,4,lantern,Vector2i(56,39))
			"bone_archer":
				var bow := _cel(atlas,2,0)
				# Select the limbs around the grip; the fist belongs to the new cel.
				var selection := PackedVector2Array([Vector2(58,14),Vector2(66,14),Vector2(79,31),Vector2(81,51),Vector2(68,77),Vector2(57,77),Vector2(64,61),Vector2(73,48),Vector2(71,32)])
				_restore_rotated(atlas,3,0,bow,selection,Vector2(75,45),Vector2(76,62),-0.48,0.82)
				_restore_rotated(atlas,3,1,bow,selection,Vector2(75,45),Vector2(76,65),-0.75,0.82)
				_restore_rotated(atlas,3,2,bow,selection,Vector2(75,45),Vector2(77,85),-1.52,0.82)
			"bone_bailiff":
				var axe := _cel(atlas,0,0)
				var selection := PackedVector2Array([Vector2(24,16),Vector2(40,15),Vector2(41,41),Vector2(38,86),Vector2(32,86),Vector2(33,41),Vector2(25,39)])
				_restore_rotated(atlas,3,0,axe,selection,Vector2(35,56),Vector2(49,60),-0.36,0.96)
				_restore_rotated(atlas,3,1,axe,selection,Vector2(35,56),Vector2(51,65),-0.51,0.96)
		var path := destination.path_join(role+".webp.b64")
		var file := FileAccess.open(path,FileAccess.WRITE)
		file.store_string(Marshalls.raw_to_base64(atlas.save_webp_to_buffer(false)))
		file.close()
		entry.runtime_sha256 = FileAccess.get_sha256(path)
		entry.v2_cells = REPAIRS[role]
		print("D420_V2_REPAIRED: ",role," ",entry.v2_cells)
	var output := FileAccess.open(destination.path_join("manifest.json"),FileAccess.WRITE)
	output.store_string(JSON.stringify(manifest,"  ")+"\n")
	output.close()
	quit()

func _cel(atlas: Image, row: int, column: int) -> Image:
	return atlas.get_region(Rect2i(column*96,row*96,96,96))

func _write(atlas: Image, row: int, column: int, pose: Image) -> void:
	atlas.blit_rect(pose,CELL,Vector2i(column*96,row*96))

func _restore(atlas: Image, row: int, column: int, part: Image, at: Vector2i) -> void:
	var pose := _cel(atlas,row,column)
	var composed := Image.create(96,96,false,Image.FORMAT_RGBA8)
	composed.blit_rect(part,Rect2i(Vector2i.ZERO,part.get_size()),at)
	composed.blend_rect(pose,CELL,Vector2i.ZERO)
	_write(atlas,row,column,composed)

func _restore_rotated(atlas: Image, row: int, column: int, part: Image, selection: PackedVector2Array, grip: Vector2, at: Vector2, angle: float, ratio: float) -> void:
	var aligned := Image.create(96,96,false,Image.FORMAT_RGBA8)
	# Inverse sampling keeps the existing steel/wood pixels crisp.
	for y in range(3,93):
		for x in range(3,93):
			var sample := grip+(Vector2(x,y)-at).rotated(-angle)/ratio
			if Geometry2D.is_point_in_polygon(sample,selection):
				aligned.set_pixel(x,y,part.get_pixelv(Vector2i(sample.round())))
	_restore(atlas,row,column,aligned,Vector2i.ZERO)

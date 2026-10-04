class_name RunCardData
extends Resource

@export var card_id: String = ""
@export var title: String = ""
@export_multiline var card_text: String = ""
@export var wizard_line: String = ""
@export var type_label: String = "СОБЫТИЕ"
@export_range(0, 2, 1) var tier: int = 0
@export_enum("combat", "event", "prototype") var resolution_type: String = "prototype"
@export_file("*.tres", "*.tscn") var target_path: String = ""
@export_file("*.png") var art_path: String = ""
@export_multiline var prototype_result_text: String = ""

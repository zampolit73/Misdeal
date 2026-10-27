extends Control

# D367: audition the three UNAPPROVED authored synthetic foley prototypes.
# No live gameplay SFX has been replaced by these samples.
const SAMPLE_FILES := [
	"res://assets/audio/pilot/d367_deal_a_parchment.wav",
	"res://assets/audio/pilot/d367_deal_b_oak.wav",
	"res://assets/audio/pilot/d367_deal_c_cursed.wav",
]
const NAMES := ["A — СУХОЙ ПЕРГАМЕНТ", "B — ДУБОВЫЙ СТОЛ", "C — ПРОКЛЯТАЯ КОЛОДА"]

@onready var preview_player: AudioStreamPlayer = $PreviewPlayer
@onready var feedback: Label = $Feedback


func _ready() -> void:
	preview_player.bus = "UI"
	for index in range(SAMPLE_FILES.size()):
		var button := get_node("Preview%d" % index) as Button
		button.pressed.connect(_play_sample.bind(index))
	for bus_name in ["UI", "Combat", "Ambience"]:
		var slider := get_node("Volume%s" % bus_name) as HSlider
		slider.value = SoundDirector.get_channel_volume(bus_name) * 100.0
		slider.value_changed.connect(_change_volume.bind(bus_name))
	feedback.text = "Выбери характер звука выкладывания карты. Это тестовые образцы."


func _play_sample(index: int) -> void:
	if index < 0 or index >= SAMPLE_FILES.size():
		return
	var stream := load(SAMPLE_FILES[index]) as AudioStream
	if stream == null:
		feedback.text = "Не удалось загрузить звук: " + NAMES[index]
		return
	preview_player.stop()
	preview_player.stream = stream
	preview_player.play()
	feedback.text = NAMES[index] + "  •  прослушивание"


func _change_volume(value: float, bus_name: String) -> void:
	SoundDirector.set_channel_volume(bus_name, value / 100.0)

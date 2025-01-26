extends VBoxContainer

@onready var musicSlider := $music/musicSlider
@onready var soundSlider := $sound/soundSlider
@onready var backButton := $backButton

signal go_back
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	musicSlider.value_changed.connect(updateMusic)
	musicSlider.drag_ended.connect(playClick)
	soundSlider.value_changed.connect(updateSounds)
	soundSlider.drag_ended.connect(playClick)
	backButton.pressed.connect(emit_signal.bind("go_back"))
	setSliders()

func updateMusic(val):
	AudioServer.set_bus_volume_db(2, linear_to_db(val/100.0))
	
func updateSounds(val):
	AudioServer.set_bus_volume_db(1, linear_to_db(val/100.0))
	
func setSliders():
	musicSlider.value = 100 * db_to_linear(AudioServer.get_bus_volume_db(2))
	soundSlider.value = 100 * db_to_linear(AudioServer.get_bus_volume_db(1))

func playClick(_d):
	AudioHandler.playSound("pops")

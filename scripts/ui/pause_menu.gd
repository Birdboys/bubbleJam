extends ColorRect

@onready var musicSlider := $pauseMargin/pauseSettingCont/music/musicSlider
@onready var soundSlider := $pauseMargin/pauseSettingCont/sound/soundSlider

func _ready() -> void:
	musicSlider.value_changed.connect(updateMusic)
	musicSlider.drag_ended.connect(playClick)
	soundSlider.value_changed.connect(updateSounds)
	soundSlider.drag_ended.connect(playClick)
	closeMenu()

		
func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("pause"): 
		get_viewport().set_input_as_handled()
		closeMenu()
	
func openMenu():
	get_tree().paused = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	setSliders()
	
func closeMenu():
	get_tree().paused = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func setSliders():
	musicSlider.value = 100 * db_to_linear(AudioServer.get_bus_volume_db(2))
	soundSlider.value = 100 * db_to_linear(AudioServer.get_bus_volume_db(1))

func updateMusic(val):
	AudioServer.set_bus_volume_db(2, linear_to_db(val/100.0))
	
func updateSounds(val):
	AudioServer.set_bus_volume_db(1, linear_to_db(val/100.0))
	
func playClick(_d):
	AudioHandler.playSound("pops")

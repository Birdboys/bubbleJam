extends Control

@onready var settingsButton := $uiMargin/mainStuff/VBoxContainer/settingsButton
@onready var tutorialButton := $uiMargin/mainStuff/VBoxContainer/tutorialButton
@onready var creditsButton := $uiMargin/mainStuff/VBoxContainer/creditsButton
@onready var mainStuff := $uiMargin/mainStuff
@onready var settingStuff := $uiMargin/settingStuff

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	mainStuff.main_button.connect(handleMainButton)
	settingStuff.go_back.connect(reset)
	reset()


func reset():
	mainStuff.visible = true
	settingStuff.visible = false
	
func handleMainButton(b):
	match b:
		"play": get_tree().change_scene_to_file("res://scenes/section1.tscn")
		"settings":
			mainStuff.visible = false
			settingStuff.visible = true

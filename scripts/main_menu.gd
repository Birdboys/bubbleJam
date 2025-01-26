extends Control

@onready var mainStuff := $uiMargin/mainStuff
@onready var settingStuff := $uiMargin/settingStuff
@onready var creditStuff := $uiMargin/creditStuff
@onready var tutorialStuff := $uiMargin/tutorialStuff

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	mainStuff.main_button.connect(handleMainButton)
	settingStuff.go_back.connect(reset)
	creditStuff.go_back.connect(reset)
	tutorialStuff.go_back.connect(reset)
	reset()


func reset():
	mainStuff.visible = true
	settingStuff.visible = false
	creditStuff.visible = false
	tutorialStuff.visible = false
	
func handleMainButton(b):
	match b:
		"play": get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
		"settings":
			mainStuff.visible = false
			settingStuff.visible = true
		"credits":
			mainStuff.visible = false
			creditStuff.visible = true
		"tutorial":
			mainStuff.visible = false
			tutorialStuff.visible = true

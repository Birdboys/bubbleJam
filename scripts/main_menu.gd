extends Control

@onready var settingsButton := $uiMargin/mainStuff/VBoxContainer/settingsButton
@onready var tutorialButton := $uiMargin/mainStuff/VBoxContainer/tutorialButton
@onready var creditsButton := $uiMargin/mainStuff/VBoxContainer/creditsButton
@onready var playButton := $uiMargin/mainStuff/VBoxContainer/playButton

func _ready() -> void:
	playButton.pressed.connect(startGame)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass

func startGame():
	get_tree().change_scene_to_file("res://scenes/section1.tscn")

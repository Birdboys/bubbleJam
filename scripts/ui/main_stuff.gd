extends VBoxContainer

@onready var playButton := $VBoxContainer/playButton
@onready var settingsButton := $VBoxContainer/settingsButton
@onready var creditsButton := $VBoxContainer/creditsButton
@onready var tutorialButton := $VBoxContainer/tutorialButton
signal main_button(b)

func _ready() -> void:
	playButton.pressed.connect(emit_signal.bind("main_button", "play"))
	settingsButton.pressed.connect(emit_signal.bind("main_button", "settings"))
	creditsButton.pressed.connect(emit_signal.bind("main_button", "credits"))
	tutorialButton.pressed.connect(emit_signal.bind("main_button", "tutorial"))

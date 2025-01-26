extends VBoxContainer

@onready var playButton := $VBoxContainer/playButton
@onready var settingsButton := $VBoxContainer/settingsButton
signal main_button(b)

func _ready() -> void:
	playButton.pressed.connect(emit_signal.bind("main_button", "play"))
	settingsButton.pressed.connect(emit_signal.bind("main_button", "settings"))

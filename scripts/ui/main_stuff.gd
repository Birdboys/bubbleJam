extends VBoxContainer

@onready var playButton := $VBoxContainer/playButton

signal main_button(b)

func _ready() -> void:
	playButton.pressed.connect(emit_signal.bind("main_button", "play"))
	

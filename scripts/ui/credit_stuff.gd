extends VBoxContainer

@onready var backButton := $backButton

signal go_back
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	backButton.pressed.connect(emit_signal.bind("go_back"))

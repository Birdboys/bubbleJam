extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ui/MarginContainer/Button.pressed.connect(toMain)
	$animationPlayer.play("end_cutscene")

func toMain():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

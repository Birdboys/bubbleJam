extends Control


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

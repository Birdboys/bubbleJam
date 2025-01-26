extends Area2D

@export var air_val := 2

func _ready() -> void:
	scale = Vector2.ONE * air_val/4.0

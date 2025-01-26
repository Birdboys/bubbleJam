extends Area2D

@export var air_val := 2

func _ready() -> void:
	scale = Vector2.ONE * air_val/4.0
	area_entered.connect(popped)

func popped(puffer: Area2D):
	AudioHandler.playSound("pops")
	queue_free()

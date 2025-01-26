extends StaticBody2D

@onready var coralSprite := $coralSprite
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = randi_range(0, 4) * PI/2.0
	coralSprite.texture = load("res://assets/coral%s.png" % randi_range(1,2))

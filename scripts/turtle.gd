extends StaticBody2D

@onready var fishFollow := $fishPath/fishFollow
@onready var fishPath := $fishPath
@onready var fishSprite := $turtleSprite
@onready var bubbleBouncer := $bubbleBouncer
@export var path_points : Array[Vector2]
@export var follow_speed := 300.0

var forward := true
var original_position : Vector2
var bounce_force := 750.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path_curve = Curve2D.new()
	for point in path_points:
		path_curve.add_point(point)
	fishPath.curve = path_curve
	original_position = position
	
	bubbleBouncer.body_entered.connect(bounceBubble)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fishFollow.progress += follow_speed * delta * (1 if forward else -1)
	if fishFollow.progress_ratio == 0.0:
		forward = true
		fishSprite.flip_h = false
	if fishFollow.progress_ratio >= 1.0:
		forward = false
		fishSprite.flip_h = true
	position = original_position + fishFollow.position.rotated(rotation)

func bounceBubble(bubble: CharacterBody2D):
	print("BUBBLE BOUNCED")
	bubble.updateVel(-1 * bounce_force * bubble.velocity.normalized())

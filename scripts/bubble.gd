extends CharacterBody2D

@onready var bubbleSprite := $bubbleSprite
@onready var bubbleCol := $bubbleCol
@onready var bubHurtBox := $bubbleHurtBox
@onready var bubCollectBox := $bubbleCollectBox
@export var bubble_scale := 2.0

var bubble_rise_speed := 125.0
var bubble_stop_speed := 650.0
var bubble_deflate_speed := 0.075
var bubble_rot_friction := PI/64.0
var bubble_push_force := 1500.0

var current_velocity := Vector2.ZERO
var current_rotation := 0.0

func _ready() -> void:
	bubHurtBox.area_entered.connect(popBubble)
	bubCollectBox.area_entered.connect(collectBubble)
	
func _process(delta: float) -> void:
	updateScale(delta)
	updateRotation(delta)

	current_velocity = current_velocity.move_toward(Vector2.UP * bubble_rise_speed, bubble_stop_speed*delta)
	velocity = current_velocity
	move_and_slide()
	
func updateScale(delta):
	bubble_scale -= bubble_deflate_speed * delta
	scale = Vector2.ONE * bubble_scale

func updateRotation(delta):
	current_rotation = move_toward(current_rotation, 0.0, bubble_rot_friction*delta)
	bubbleSprite.rotate(current_rotation)

func popBubble(enemy: Area2D):
	print("BUBBLE POPPED")
	pass

func collectBubble(bub: Area2D):
	var added_air_val = bub.air_val
	bubble_scale += added_air_val
	bubble_scale = clampf(bubble_scale, 0.0, 2.0)
	bub.queue_free()
	
func pushBubble(push_dir, push_dist):
	print("BUBBLE PUSHED")
	var dist_mod = remap(clamp(push_dist, 0, 1000), 0, 1000, 1.0, 0.2)
	current_velocity = push_dir * dist_mod * bubble_push_force 
	if push_dir.x >= 0:
		current_rotation = PI/32.0 * dist_mod
	else:
		current_rotation = -PI/32.0 * dist_mod

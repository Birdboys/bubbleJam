extends CharacterBody2D

@onready var bubbleSprite := $bubbleSprite
@onready var bubbleCol := $bubbleCol
@onready var bubHurtBox := $bubbleHurtBox
@onready var bubCollectBox := $bubbleCollectBox
@onready var otterSprite := $otterSprite
@export var bubble_scale := 1.0

var bubble_rise_speed := 125.0
var bubble_stop_speed := 650.0
var bubble_deflate_speed := 0 #0.075
var bubble_rot_friction := PI/64.0
var bubble_push_force := 1500.0

var current_velocity := Vector2.ZERO
var current_rotation := 0.0
var is_playing := false

func _ready() -> void:
	bubHurtBox.area_entered.connect(popBubble)
	bubCollectBox.area_entered.connect(collectBubble)
	updateScale(0.0)
	updateOtter(0.0)
	
func _process(delta: float) -> void:
	if not is_playing: return
	updateScale(delta)
	updateRotation(delta)
	updateOtter(delta)
	
	current_velocity = current_velocity.move_toward(Vector2.UP * bubble_rise_speed, bubble_stop_speed*delta)
	velocity = current_velocity
	move_and_slide()
	
func updateScale(delta):
	bubble_scale -= bubble_deflate_speed * delta
	bubble_scale = clamp(bubble_scale, 0.0, 1.0)
	scale = 3 * Vector2.ONE * bubble_scale
	otterSprite.scale = 3 * Vector2.ONE * bubble_scale

func updateRotation(delta):
	current_rotation = move_toward(current_rotation, 0.0, bubble_rot_friction*delta)
	bubbleSprite.rotate(current_rotation)

func updateOtter(delta):
	otterSprite.rotate(-current_rotation/5.0)
	otterSprite.rotation = move_toward(otterSprite.rotation, 0.0, bubble_rot_friction*10.0*delta)
	otterSprite.rotation = clampf(otterSprite.rotation, -PI/5, PI/5)
	otterSprite.position = position
	
func updateVel(v):
	current_velocity = v
	
func popBubble(enemy: Area2D):
	if not is_playing: return
	print("BUBBLE POPPED")
	AudioHandler.playSound("pops")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func collectBubble(bub: Area2D):
	var added_air_val = bub.air_val
	bubble_scale += added_air_val/16.0
	bubble_scale = clampf(bubble_scale, 0.0, 1.0)
	bub.queue_free()
	AudioHandler.playSound("absorbs")
	
func pushBubble(push_dir, push_dist):
	print("BUBBLE PUSHED")
	var dist_mod = remap(clamp(push_dist, 0, 1000), 0, 1000, 1.0, 0.2)
	current_velocity = push_dir * dist_mod * bubble_push_force 
	if push_dir.x >= 0:
		current_rotation = PI/32.0 * dist_mod
	else:
		current_rotation = -PI/32.0 * dist_mod

extends CharacterBody2D

enum puffer_states {PUFFED, EMPTY, DAMAGED, IDLE}

@onready var pufferSprite := $pufferSprite
@onready var pufferCol := $pufferCol
@onready var pufferHitBox := $pufferHitBox
@onready var pufferHurtBox := $pufferHurtBox
@onready var pufferAnim := $pufferAnim
@onready var puffed_sprite := preload("res://assets/puffer/puffer_hold.png")
@onready var out_sprite := preload("res://assets/puffer/puffer_hold.png")
@onready var in_sprite := preload("res://assets/puffer/puffer_in.png")
@onready var neutral_sprite := preload("res://assets/puffer/puffer_neutral.png")

@export var puffer_scale := 0.0
@export var current_state := puffer_states.IDLE
var puff_recharge_time := 1.0
var puff_cooldown := 1.0
var damage_timeout := 0.5
var fish_speed := 10000.0

var hp := 3

signal do_puff

func _ready() -> void:
	pufferHurtBox.area_entered.connect(pufferHurt)
	puffer_scale = 0.0
	updateScale()
	#pufferEmpty()
	
func _process(delta: float) -> void:
	handleMovement(delta)
	updateScale()
	match current_state:
		puffer_states.PUFFED:
			if Input.is_action_just_pressed("puff"):
				doPuff()

func handleMovement(delta):
	var new_pos = get_global_mouse_position()
	var new_dir = position.direction_to(new_pos)
	var new_dist = position.distance_to(new_pos)
	velocity = new_dir * fish_speed * clamp(new_dist, 0, 200.0)/200.0
	move_and_slide()
	
func handleRotation(bubble_pos):
	pufferSprite.rotation = transform.looking_at(bubble_pos).get_rotation()
	pufferSprite.flip_v = position.x > bubble_pos.x
	
func updateScale():
	var new_scale = Vector2.ONE + (Vector2.ONE * puffer_scale)
	pufferSprite.scale = new_scale
	pufferCol.scale = new_scale
	pufferHitBox.scale = new_scale
	pufferHurtBox.scale = new_scale

func updateRot(bubble_pos):
	var relative_bubble_pos = to_local(bubble_pos)
	
func doPuff():
	emit_signal("do_puff")
	current_state = puffer_states.EMPTY
	pufferAnim.play("puff")
	
func pufferFull():
	current_state = puffer_states.PUFFED
	pufferSprite.texture = puffed_sprite
	
func pufferEmpty():
	current_state = puffer_states.EMPTY
	pufferSprite.texture = in_sprite
	puffer_scale = 0.0
	updateScale()
	pufferAnim.play("charge")
	
func pufferHurt(obstacle: Area2D):
	if current_state == puffer_states.DAMAGED or current_state == puffer_states.IDLE: return
	hp -= 1
	if hp == 0: get_tree().quit()
	current_state = puffer_states.DAMAGED
	pufferAnim.play("damage")
	AudioHandler.playSound("puff_hurt")
	

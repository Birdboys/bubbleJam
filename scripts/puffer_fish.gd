extends CharacterBody2D

enum puffer_states {PUFFED, EMPTY, DAMAGED, IDLE}

@onready var pufferSprite := $pufferSprite
@onready var pufferCol := $pufferCol
@onready var pufferHitBox := $pufferHitBox
@onready var pufferHurtBox := $pufferHurtBox
@onready var pufferCoinBox := $pufferCoinBox
@onready var waterSound := $waterSound
@onready var pufferAnim := $pufferAnim
@onready var puffRay := $puffRay
@onready var puffed_sprite := preload("res://assets/puffer/puffer_hold.png")
@onready var out_sprite := preload("res://assets/puffer/puffer_hold.png")
@onready var in_sprite := preload("res://assets/puffer/puffer_in.png")
@onready var neutral_sprite := preload("res://assets/puffer/puffer_neutral.png")
@export var puffer_scale := 0.0
@export var current_state := puffer_states.IDLE
@export var movement_penalty := 1.0

var puff_recharge_time := 1.0
var puff_cooldown := 1.0
var damage_timeout := 0.5
var fish_speed := 7500.0
var movement_sound_max_dist := 200.0
var prev_pos : Vector2
var damaged_movement_reduction := 0.25

var hp := 3

signal do_puff
signal coin_collected 
signal death

func _ready() -> void:
	pufferHurtBox.area_entered.connect(pufferHurt)
	pufferCoinBox.area_entered.connect(collectCoin)
	puffer_scale = 0.0
	prev_pos = position
	updateScale()
	#pufferEmpty()
	
func _process(delta: float) -> void:
	updateScale()
	match current_state:
		puffer_states.PUFFED:
			handleMovement(delta)
			handleWaterSound(delta)
			if Input.is_action_just_pressed("puff"):
				doPuff()
		puffer_states.EMPTY, puffer_states.DAMAGED:
			handleMovement(delta)
			handleWaterSound(delta)

func _physics_process(delta: float) -> void:
	print(db_to_linear(waterSound.volume_db)*100)
	
func handleMovement(delta):
	var new_pos = get_global_mouse_position()
	var new_dir = position.direction_to(new_pos)
	var new_dist = position.distance_to(new_pos)
	velocity = new_dir * fish_speed * movement_penalty * clamp(new_dist, 0, 400.0)/400.0 
	move_and_slide()
	
func handleRotation(bubble_pos):
	pufferSprite.rotation = transform.looking_at(bubble_pos).get_rotation()
	pufferSprite.flip_v = position.x > bubble_pos.x

func handleWaterSound(delta):
	var pos_diff = position.distance_to(prev_pos)
	pos_diff = clamp(pos_diff, 0.0, movement_sound_max_dist)/movement_sound_max_dist
	waterSound.volume_db = linear_to_db(pos_diff)
	prev_pos = position

func updateScale():
	var new_scale = Vector2.ONE + (Vector2.ONE * puffer_scale)
	pufferSprite.scale = new_scale
	pufferCol.scale = new_scale
	pufferHitBox.scale = new_scale
	pufferHurtBox.scale = new_scale
	pufferCoinBox.scale = new_scale

func updateRot(bubble_pos):
	var relative_bubble_pos = to_local(bubble_pos)
	
func doPuff():
	emit_signal("do_puff")
	current_state = puffer_states.EMPTY
	pufferAnim.play("puff")

func doesPuffConnect(pos):
	puffRay.target_position = to_local(pos)
	puffRay.force_raycast_update()
	print("TRYING TO CONNECT")
	if puffRay.is_colliding():
		var col = puffRay.get_collider()
		return not col.get_collision_layer_value(1)
	else:
		print("NO CONNECT")
		return false
		
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
	print(hp)
	if hp <= 0: 
		emit_signal("death")
	current_state = puffer_states.DAMAGED
	pufferAnim.play("damage")
	AudioHandler.playSound("puff_hurt")

func collectCoin(coin):
	print("Collected coin")
	coin.queue_free()
	emit_signal("coin_collected")

extends CharacterBody2D

enum puffer_states {PUFFED, EMPTY, DAMAGED}

@onready var pufferSprite := $pufferSprite
@onready var pufferCol := $pufferCol
@onready var pufferHitBox := $pufferHitBox
@onready var pufferHurtBox := $pufferHurtBox
@onready var pufferAnim := $pufferAnim
@onready var puffed_sprite := preload("res://assets/temp/puffer.png")
@onready var empty_sprite := preload("res://assets/temp/puffer.png")
@export var puffer_scale := 1.0
@export var current_state := puffer_states.PUFFED
var puff_recharge_time := 1.0
var puff_cooldown := 1.0
var damage_timeout := 0.5

var hp := 3

signal do_puff

func _ready() -> void:
	pufferHurtBox.area_entered.connect(pufferHurt)
	updateScale()
	pufferEmpty()
	
func _process(delta: float) -> void:
	position = get_global_mouse_position()
	
	match current_state:
		puffer_states.PUFFED:
			if Input.is_action_just_pressed("puff"):
				doPuff()
		puffer_states.EMPTY:
			updateScale()
		puffer_states.DAMAGED:
			updateScale()

func handleRotation(bubble_pos):
	pufferSprite.rotation = transform.looking_at(bubble_pos).get_rotation()
	pufferSprite.flip_v = position.x > bubble_pos.x
	
func updateScale():
	var new_scale = Vector2.ONE + (Vector2.ONE * puffer_scale)
	pufferSprite.scale = new_scale
	pufferCol.scale = new_scale
	pufferHitBox.scale = new_scale

func updateRot(bubble_pos):
	var relative_bubble_pos = to_local(bubble_pos)
	
func doPuff():
	emit_signal("do_puff")
	pufferEmpty()
	

func pufferFull():
	current_state = puffer_states.PUFFED
	
func pufferEmpty():
	current_state = puffer_states.EMPTY
	pufferSprite.texture = empty_sprite
	puffer_scale = 0.0
	updateScale()
	pufferAnim.play("charge")
	
func pufferHurt(obstacle: Area2D):
	if current_state == puffer_states.DAMAGED: return
	hp -= 1
	if hp == 0: get_tree().quit()
	current_state = puffer_states.DAMAGED
	pufferAnim.play("damage")
	AudioHandler.playSound("puff_hurt")
	

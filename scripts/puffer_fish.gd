extends CharacterBody2D

@onready var pufferSprite := $pufferSprite
@onready var pufferCol := $pufferCol
@onready var pufferHitBox := $pufferHitBox
@onready var pufferHurtBox := $pufferHurtBox
@onready var puffed_sprite := preload("res://assets/temp/puffer.png")
@onready var empty_sprite := preload("res://assets/temp/puffer.png")
@export var puffer_scale := 1.0

enum puffer_states {PUFFED, EMPTY, DAMAGED}
var current_state := puffer_states.PUFFED
var puff_cooldown := 1.0

var hp := 3

signal do_puff

func _ready() -> void:
	pufferHurtBox.area_entered.connect(pufferHurt)
	updateScale()
	
func _process(delta: float) -> void:
	match current_state:
		puffer_states.PUFFED:
			if Input.is_action_just_pressed("puff"):
				doPuff()
		puffer_states.EMPTY:
			updateScale()
	handleMovement()

func handleMovement():
	match current_state:
		puffer_states.PUFFED, puffer_states.EMPTY: 
			position = get_global_mouse_position()
		_:
			pass

func handleRotation(bubble_pos):
	pufferSprite.rotation = transform.looking_at(bubble_pos).get_rotation()
	pufferSprite.flip_v = position.x > bubble_pos.x
	
func updateScale():
	var new_scale = Vector2.ONE + (Vector2.ONE * puffer_scale)
	pufferSprite.scale = new_scale
	pufferCol.scale = new_scale

func updateRot(bubble_pos):
	var relative_bubble_pos = to_local(bubble_pos)
	
func doPuff():
	current_state = puffer_states.EMPTY
	pufferSprite.texture = empty_sprite
	puffer_scale = 0.0
	emit_signal("do_puff")
	var puff_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	puff_tween.tween_property(self, "puffer_scale", 1.0, puff_cooldown)
	puff_tween.tween_callback(resetPuff)
	
func resetPuff():
	current_state = puffer_states.PUFFED
	pufferSprite.texture = puffed_sprite
	puffer_scale = 1.0
	
func pufferHurt(obstacle: Area2D):
	print("PUFFER WAS HIT")
	hp -= 1
	#if hp == 0: quit()

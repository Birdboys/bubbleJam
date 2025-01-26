extends Node2D

@onready var puffer := $pufferFish
@onready var bubble := $bubble
@onready var cam := $playerCam
@onready var camTrigger := $camTrigger
@onready var death_bubble_scene := preload("res://scenes/death_bubble.tscn")
@onready var death_puffer_scene := preload("res://scenes/death_puffer.tscn")

var cam_move_speed := 750.0
var cam_follow = false
var is_playing = true
var finished = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	puffer.do_puff.connect(handlePuff)
	bubble.death.connect(handleDeath)
	camTrigger.body_exited.connect(startCamTracking)
	get_tree().create_timer(2.0).timeout.connect(startGame)
	
func _process(delta: float) -> void:
	if is_playing:
		puffer.handleRotation(bubble.position)
		if cam_follow: cam.position = cam.position.move_toward(bubble.position, cam_move_speed*delta)

func handlePuff():
	if is_playing:
		var push_dir = -(bubble.position.direction_to(puffer.position).normalized())
		var push_dist = bubble.position.distance_to(puffer.position)
		bubble.pushBubble(push_dir, push_dist)

func handleDeath():
	# instantiate fake bubble and puffer to animate
	var death_bubble = death_bubble_scene.instantiate()
	var death_puffer = death_puffer_scene.instantiate()
	add_child(death_bubble)
	add_child(death_puffer)
	death_bubble.scale = bubble.scale
	death_bubble.position = bubble.position
	death_bubble.rotation = bubble.rotation
	death_puffer.scale = puffer.scale
	death_puffer.position = puffer.position
	death_puffer.rotation = puffer.rotation
	bubble.queue_free()
	puffer.queue_free()
	is_playing = false
	
	# animate fake bubble
	var bub_fall_tween = create_tween().set_parallel().set_ease(Tween.EASE_IN)
	bub_fall_tween.tween_property(death_bubble, "position", death_bubble.position + Vector2(0,3000), 2)
	bub_fall_tween.tween_property(death_bubble, "rotation", 1.6, 2)
	
	# animate fake puffer
	var puff_fall_tween = create_tween().set_parallel().set_ease(Tween.EASE_IN)
	puff_fall_tween.tween_property(death_puffer, "position", death_puffer.position + Vector2(0,3000), 2)
	puff_fall_tween.tween_property(death_puffer, "rotation", -2.8, 2)
	print("me die")
	get_tree().create_timer(1.8).timeout.connect(deathScreen)

func deathScreen():
	if finished: return
	finished = true
	print('show deaths screen')
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func startGame():
	puffer.pufferEmpty()
	bubble.is_playing = true

func startCamTracking(_bub):
	cam_follow = true

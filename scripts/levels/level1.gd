extends Node2D

@onready var puffer := $pufferFish
@onready var bubble := $bubble
@onready var cam := $playerCam
@onready var timerLabel := $uiLayer/uiMargin/timerLabel
@onready var winZone := $winZone
@onready var death_bubble_scene := preload("res://scenes/death_bubble.tscn")
@onready var death_puffer_scene := preload("res://scenes/death_puffer.tscn")
@export var level_num := 0

var cam_move_speed := 750.0
var is_playing = true
var finished = false
var game_time := 0.0
var coins_collected := 0
var current_level
var puffer_hp := 0

func _ready() -> void:
	DeathScreen.resetGameData()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	puffer.do_puff.connect(handlePuff)
	puffer.coin_collected.connect(coinCollected)
	puffer.death.connect(handleDeath)
	bubble.death.connect(handleDeath)
	winZone.body_entered.connect(handleWin)
	get_tree().create_timer(2.0).timeout.connect(startGame)

func _process(delta: float) -> void:
	if is_playing:
		game_time += delta
		timerLabel.text = str(int(game_time))
		puffer.handleRotation(bubble.position)
		cam.position = cam.position.move_toward(bubble.position, cam_move_speed*delta)

func initializeGame(t):
	game_time = t

func handlePuff():
	if is_playing and puffer.doesPuffConnect(bubble.position):
		var push_dir = -(bubble.position.direction_to(puffer.position).normalized())
		var push_dist = bubble.position.distance_to(puffer.position)
		bubble.pushBubble(push_dir, push_dist)

func startGame():
	puffer.pufferEmpty()
	bubble.is_playing = true

func coinCollected():
	coins_collected += 1

func handleWin(_bub):
	print("WONNERTON")
	if not is_playing: return
	is_playing = false
	var bubble_tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	bubble_tween.tween_property(bubble, "position", bubble.position + Vector2.UP*3000, 2.0)
	bubble_tween.tween_callback(deathScreen.bind(true))
	
func handleDeath():
	if not is_playing: return
	is_playing = false
	puffer_hp = puffer.hp
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
	
	# animate fake bubble
	var bub_fall_tween = create_tween().set_parallel().set_ease(Tween.EASE_IN)
	bub_fall_tween.tween_property(death_bubble, "position", death_bubble.position + Vector2(0,3000), 2)
	bub_fall_tween.tween_property(death_bubble, "rotation", 1.6, 2)
	
	# animate fake puffer
	var puff_fall_tween = create_tween().set_parallel().set_ease(Tween.EASE_IN)
	puff_fall_tween.tween_property(death_puffer, "position", death_puffer.position + Vector2(0,3000), 2)
	puff_fall_tween.tween_property(death_puffer, "rotation", -2.8, 2)
	print("me die")
	get_tree().create_timer(1.0).timeout.connect(deathScreen.bind(false))

func deathScreen(win:bool):
	DeathScreen.showDeathScreen(win, game_time, coins_collected, puffer_hp)
	

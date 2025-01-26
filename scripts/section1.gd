extends Node2D

@onready var puffer := $pufferFish
@onready var bubble := $bubble
@onready var cam := $playerCam
@onready var waterPlayer := $waterPlayer
@onready var timerLabel := $uiLayer/uiMargin/timerLabel
@onready var camTrigger := $camTrigger

var cam_move_speed := 250.0
var game_time := 0.0
var game_started := false
var track_cam := false
var prev_mouse_pos : Vector2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	puffer.do_puff.connect(handlePuff)
<<<<<<< HEAD
	bubble.death.connect(handleDeath)
=======
	camTrigger.body_exited.connect(startCamTracking)
>>>>>>> 84efa02f26bd553cf53c8b4420f6166a3145206c
	get_tree().create_timer(2.0).timeout.connect(startGame)
	prev_mouse_pos = get_global_mouse_position()
	
func _process(delta: float) -> void:
	puffer.handleRotation(bubble.position)
	if game_started:
		game_time += delta
		timerLabel.text = str(int(game_time))
		handleWaterPlayer()
	if track_cam:
		cam.position = cam.position.move_toward(bubble.position, cam_move_speed*delta)
		
func handlePuff():
	var push_dir = -(bubble.position.direction_to(puffer.position).normalized())
	var push_dist = bubble.position.distance_to(puffer.position)
	bubble.pushBubble(push_dir, push_dist)

func handleDeath():
	print("me die")

func startGame():
	puffer.pufferEmpty()
	bubble.is_playing = true
	game_started = true
	waterPlayer.play(0.0)

func startCamTracking(_bubble):
	print("START TRACKING")
	track_cam = true
	
func handleWaterPlayer():
	var current_pos = get_local_mouse_position()
	var pos_diff = prev_mouse_pos.distance_to(current_pos)
	pos_diff = clamp(pos_diff, 0.0, 200.0)/200.0
	prev_mouse_pos = current_pos
	waterPlayer.volume_db = linear_to_db(pos_diff)

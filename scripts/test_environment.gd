extends Node2D

@onready var puffer := $pufferFish
@onready var bubble := $bubble
@onready var cam := $playerCam

var cam_move_speed := 150.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	puffer.do_puff.connect(handlePuff)
	get_tree().create_timer(2.0).timeout.connect(startGame)
	
func _process(delta: float) -> void:
	cam.position = cam.position.move_toward(bubble.position, cam_move_speed)
	puffer.handleRotation(bubble.position)
	
func handlePuff():
	var push_dir = -(bubble.position.direction_to(puffer.position).normalized())
	var push_dist = bubble.position.distance_to(puffer.position)
	bubble.pushBubble(push_dir, push_dist)
func startGame():
	puffer.pufferEmpty()
	bubble.is_playing = true

extends Node2D

@onready var puffer := $pufferFish
@onready var bubble := $bubble
@onready var cam := $playerCam
@onready var timerLabel := $uiLayer/uiMargin/timerLabel

var cam_move_speed := 750.0
var is_playing = true
var finished = false
var game_time := 0.0

func _ready() -> void:
	pass # Replace with function body.

func initializeGame(t):
	game_time = t

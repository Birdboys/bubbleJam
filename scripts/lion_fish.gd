extends StaticBody2D

@onready var fishFollow := $fishPath/fishFollow
@onready var fishPath := $fishPath
@onready var fishSprite := $lionFishSprite
@export var path_points : Array[Vector2]
@export var follow_speed := 300.0
@export var start_wait_time := 0.0

var going := false
var forward := true
var original_position : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path_curve = Curve2D.new()
	for point in path_points:
		path_curve.add_point(point)
	fishPath.curve = path_curve
	original_position = position
	get_tree().create_timer(start_wait_time).timeout.connect(startSwimming)

func _process(delta: float) -> void:
	if not going: return
	fishFollow.progress += follow_speed * delta * (1 if forward else -1)
	if fishFollow.progress_ratio == 0.0:
		forward = true
		fishSprite.flip_h = false
	if fishFollow.progress_ratio >= 1.0:
		forward = false
		fishSprite.flip_h = true
	position = original_position + fishFollow.position
	#print(fishFollow.progress_ratio)

func startSwimming():
	going = true

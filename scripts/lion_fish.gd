extends StaticBody2D

@onready var fishFollow := $fishPath/fishFollow
@onready var fishPath := $fishPath
@export var path_points : Array[Vector2]
@export var follow_speed := 300.0

var forward := true
var original_position : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path_curve = Curve2D.new()
	for point in path_points:
		path_curve.add_point(point)
	fishPath.curve = path_curve
	original_position = position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fishFollow.progress += follow_speed * delta * (1 if forward else -1)
	if fishFollow.progress_ratio == 0.0:
		forward = true
	if fishFollow.progress_ratio == 1.0:
		forward = false
	position = fishFollow.position
	print(fishFollow.position)

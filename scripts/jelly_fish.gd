extends StaticBody2D

@onready var jellySprite := $jellyFishSprite
@onready var jellyHurtBox := $jellyFishHurtBox
@onready var jellyPushBox := $jellyFishPushBox
@onready var jellyDetector := $jellyDetectorArea
@onready var bubbleTimer := $bubbleTimer

var bubble_detect_time := 2.0
var bounce_force := 1250.0
var pushing := false
var push_distance := 2

func _ready() -> void:
	jellyDetector.body_entered.connect(bubbleEnteredArea)
	jellyDetector.body_exited.connect(bubbleExitedArea)
	jellyPushBox.body_entered.connect(pushBubble)
	bubbleTimer.timeout.connect(startPush)
	
func bubbleEnteredArea(_bub):
	bubbleTimer.start(bubble_detect_time)

func bubbleExitedArea(_bub):
	bubbleTimer.stop()

func startPush():
	if pushing: return
	pushing = true
	
	var bubble_check = jellyPushBox.get_overlapping_bodies()
	if len(bubble_check) > 0:
		pushBubble(bubble_check[0])
		
	var og_pos = position
	var new_pos = position + (Vector2.UP * push_distance*200).rotated(rotation)
	var push_tween := get_tree().create_tween()
	push_tween.tween_property(self, "position", new_pos, 0.5)
	push_tween.tween_interval(0.1)
	push_tween.tween_property(self, "position", og_pos, 0.5)
	push_tween.tween_callback(stopPush)
	
func stopPush():
	pushing = false

func pushBubble(bubble: CharacterBody2D):
	bubble.updateVel(Vector2.UP.rotated(rotation) * bounce_force)

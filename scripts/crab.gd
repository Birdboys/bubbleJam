extends StaticBody2D
enum states {IDLE, TRACKING, ATTACKING}
@onready var crabClaw := $crabClaw
@onready var bubbleLocArea := $bubbleLocArea
@onready var attackTimer := $attackTimer

@export var tracking_time := 3.0

var claw_tracking_rate := PI/1.5
var original_claw_rot = deg_to_rad(-50)
var attack_distance := 300.0
var windup_distance := 75.0
var current_state = states.IDLE
var bubble 

func _ready() -> void:
	bubbleLocArea.body_entered.connect(bubbleEntered)
	bubbleLocArea.body_exited.connect(bubbleExited)
	attackTimer.timeout.connect(startAttack)
	
func _process(delta: float) -> void:
	match current_state:
		states.IDLE:
			crabClaw.rotation = rotate_toward(crabClaw.rotation, original_claw_rot, claw_tracking_rate * delta) 
		states.TRACKING:
			if bubble != null:
				var new_rot = crabClaw.transform.looking_at(to_local(bubble.position)).get_rotation()+PI/2.0
				crabClaw.rotation = rotate_toward(crabClaw.rotation, new_rot, claw_tracking_rate * delta) 
		states.ATTACKING:
			pass
			

func bubbleEntered(bub: CharacterBody2D):
	bubble = bub
	current_state = states.TRACKING
	attackTimer.start(tracking_time)
	
func bubbleExited(bub: CharacterBody2D):
	bubble = null
	if current_state == states.TRACKING:
		current_state = states.IDLE
		attackTimer.stop()
		
func startAttack():
	current_state = states.ATTACKING
	var original_pos = crabClaw.position
	var attack_dir = Vector2.UP.rotated(crabClaw.rotation)
	var windup_pos = original_pos - windup_distance * attack_dir
	var attack_pos = original_pos + attack_distance * attack_dir
	var attack_tween := get_tree().create_tween().set_ease(Tween.EASE_IN)
	attack_tween.tween_property(crabClaw, "position", windup_pos, 0.5)
	attack_tween.tween_interval(1.0)
	attack_tween.set_ease(Tween.EASE_OUT)
	attack_tween.tween_property(crabClaw, "position", attack_pos, 0.2)
	attack_tween.tween_property(crabClaw, "position", original_pos, 1.0)
	attack_tween.tween_callback(finishAttack)
	
func finishAttack():
	if bubble == null:
		current_state = states.IDLE
	else:
		current_state = states.TRACKING
		attackTimer.start(tracking_time)

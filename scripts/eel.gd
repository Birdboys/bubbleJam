extends StaticBody2D

@onready var eelSprite := $eelSprite
@onready var eelTimer := $eelTimer
@onready var electrics := $electricity
@onready var electricity := preload("res://scenes/eel_electricity.tscn")
@onready var zapSprite := preload("res://assets/eel_zap.png")
@onready var normSprite := preload("res://assets/eel_neutral.png")
@export var electricity_length := 6
@export var time_offset := 0.0
@export var time_on := 2.0
@export var time_off := 4.0
@export var sprite_change_delay := 2.0

var on := false

func _ready() -> void:
	eelTimer.start(time_off+time_offset)
	get_tree().create_timer(time_off+time_offset-sprite_change_delay).timeout.connect(changeToZapSprite)
	eelTimer.timeout.connect(toggleElectricity)
	
func toggleElectricity():
	on = not on
	if on:
		startElectric()
	else:
		stopElectric()
		
func startElectric():
	for x in range(electricity_length):
		var new_elec = electricity.instantiate()
		electrics.add_child(new_elec)
		new_elec.position.x = x * 200
	eelTimer.start(time_on)

func changeToZapSprite():
	eelSprite.texture = zapSprite
	
func stopElectric():
	eelSprite.texture = normSprite
	for e in electrics.get_children():
		e.queue_free()
	get_tree().create_timer(time_off-sprite_change_delay).timeout.connect(changeToZapSprite)
	eelTimer.start(time_off)

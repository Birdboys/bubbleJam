extends StaticBody2D

@onready var eelSprite := $eelSprite
@onready var eelTimer := $eelTimer
@onready var electrics := $electricity
@onready var electricity := preload("res://scenes/eel_electricity.tscn")
@export var electricity_length := 6
@export var time_offset := 0.0

var on := false
@export var time_on := 2
@export var time_off := 5.0



func _ready() -> void:
	get_tree().create_timer(time_offset).timeout.connect(eelTimer.start.bind(time_on))
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

func stopElectric():
	for e in electrics.get_children():
		e.queue_free()

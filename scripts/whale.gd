extends Node2D

@onready var suckArea := $suckArea
@onready var biteArea := $biteArea
@onready var whaleSprite := $whaleSprite
@onready var whirlpoolParts := $whirlpoolParticles
@onready var open_sprite := preload("res://assets/orca_open.png")
@onready var closed_sprite := preload("res://assets/orca_closed.png")

var suck_strength := 700.0
var open := false
var bubble : CharacterBody2D

func _ready() -> void:
	suckArea.body_entered.connect(toggleSuck.bind(true))
	suckArea.body_exited.connect(toggleSuck.bind(false))
	biteArea.body_entered.connect(handleBite)
	
func _process(delta: float) -> void:
	if open and bubble != null:
		handleSuck(delta)

func toggleSuck(bub, on):
	open = on
	whirlpoolParts.emitting = on
	if open:
		whaleSprite.texture = open_sprite
		bubble = bub
		bubble.in_whirlpool = true
	else:
		whaleSprite.texture = closed_sprite
		bubble.in_whirlpool = false
		bubble = null

func handleSuck(delta):
	var suck_dir = bubble.position.direction_to(position)
	bubble.modifyVel(suck_dir * suck_strength * delta)

func handleBite(b):
	toggleSuck(null, false)

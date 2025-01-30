extends Area2D

@onready var sprite := $electricitySprite
@onready var zap1 := preload("res://assets/zap1.png")
@onready var zap2 := preload("res://assets/zap2.png")
@onready var zap3 := preload("res://assets/zap3.png")

func initZap(front=false):
	if front:
		sprite.texture = zap1
	else:
		sprite.texture = zap2 if randf() < 0.5 else zap3

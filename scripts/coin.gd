extends Sprite2D
@onready var coinHitBox := $coinHitBox

# Called when the node enters the scene tree for the first time.
func _ready():
	coinHitBox.body_entered.connect(collectCoin)

func collectCoin(fish: CharacterBody2D):
	print("Collected coin")
	queue_free()

extends CanvasLayer

enum levels {LEVEL0, LEVEL1, LEVEL2, LEVEL3, LEVEL4, LEVEL5, NONE}
@onready var coinData := $deathScreenMargin/deathScreenPanel/margin/bubble/coinCont/coinData
@onready var timeData := $deathScreenMargin/deathScreenPanel/margin/bubble/timeCont/timeData
@onready var hpData := $deathScreenMargin/deathScreenPanel/margin/bubble/hpCount/hpData
@onready var levelButton := $deathScreenMargin/deathScreenPanel/margin/bubble/lossButtons/restartLevel
@onready var gameButton := $deathScreenMargin/deathScreenPanel/margin/bubble/lossButtons/restartGame
@onready var nextButton := $deathScreenMargin/deathScreenPanel/margin/bubble/winButtons/nextLevel
@onready var mainButtonL := $deathScreenMargin/deathScreenPanel/margin/bubble/lossButtons/mainMenu
@onready var mainButtonW := $deathScreenMargin/deathScreenPanel/margin/bubble/winButtons/mainMenu
@onready var winButtons := $deathScreenMargin/deathScreenPanel/margin/bubble/winButtons
@onready var winLabel := $deathScreenMargin/deathScreenPanel/margin/bubble/winLabel
@onready var lossButtons := $deathScreenMargin/deathScreenPanel/margin/bubble/lossButtons
@onready var lossLabel := $deathScreenMargin/deathScreenPanel/margin/bubble/lossLabel
var game_time : int
var current_level := 1
var coins_collected := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resetGameData()
	mainButtonL.pressed.connect(backToMain)
	mainButtonW.pressed.connect(backToMain)
	levelButton.pressed.connect(restartLevel)
	gameButton.pressed.connect(restartGame)
	nextButton.pressed.connect(nextLevel)
	hideDeathScreen()

func showDeathScreen(win: bool, time, coins, hp):
	visible = true
	if win:
		winLabel.visible = true
		lossLabel.visible = false
		winButtons.visible = true
		lossButtons.visible = false
		coins_collected += coins
	else:
		winLabel.visible = false
		lossLabel.visible = true
		winButtons.visible = false
		lossButtons.visible = true
		
	coinData.text = "%s/3" % coins

	game_time = time
	timeData.text = "%ss" % int(game_time)
	hpData.text = "%s/3" % int(hp)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	
func hideDeathScreen():
	visible = false
	winLabel.visible = false
	lossLabel.visible = false
	winButtons.visible = false
	lossButtons.visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func backToMain():
	hideDeathScreen()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func restartLevel():
	hideDeathScreen()
	get_tree().reload_current_scene()

func restartGame():
	hideDeathScreen()
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")

func resetGameData():
	coins_collected = 0
	current_level = 1
	game_time = 0.0

func nextLevel():
	hideDeathScreen()
	current_level += 1
	match current_level:
		6:
			get_tree().change_scene_to_file("res://scenes/end.tscn")
		_:
			get_tree().change_scene_to_file("res://scenes/levels/level%s.tscn" % current_level)
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		var capture = get_viewport().get_texture().get_image()
		var _time = Time.get_ticks_msec()
		var filename = "user://Screenshot-{0}.png".format({"0":_time})
		capture.save_png(filename)

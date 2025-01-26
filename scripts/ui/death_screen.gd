extends CanvasLayer

enum levels {LEVEL0, LEVEL1, LEVEL2, LEVEL3, LEVEL4, LEVEL5, NONE}
@onready var coinData := $deathScreenMargin/deathScreenPanel/margin/bubble/coinCont/coinData
@onready var timeData := $deathScreenMargin/deathScreenPanel/margin/bubble/timeCont/timeData
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
var current_level := levels.NONE
var coins_collected := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mainButtonL.pressed.connect(backToMain)
	mainButtonW.pressed.connect(backToMain)
	levelButton.pressed.connect(restartLevel)
	gameButton.pressed.connect(restartGame)
	nextButton.pressed.connect(nextLevel)
	hideDeathScreen()

func showDeathScreen(win: bool, lvl, time, coins):
	visible = true
	if win:
		winLabel.visible = true
		lossLabel.visible = false
		winButtons.visible = true
		lossButtons.visible = false
	else:
		winLabel.visible = false
		lossLabel.visible = true
		winButtons.visible = false
		lossButtons.visible = true
		
	current_level = lvl
	
	coins_collected += coins
	coinData.text = "%s/3" % coins

	game_time += time
	timeData.text = "%ss" % int(game_time)
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
	get_tree().change_scene_to_file("res://scenes/section1.tscn")

func resetGameData():
	coins_collected = 0
	current_level = levels.NONE
	game_time = 0.0

func nextLevel():
	hideDeathScreen()
	match current_level:
		levels.LEVEL0:
			get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")

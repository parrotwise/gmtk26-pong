class_name MainMenu extends Node2D

@onready var menu: Control = %Menu
@onready var game_scene: GameScene = %GameScene
@onready var play_button: Button = %Play
@onready var victory_defeat_label: Label = %VictoryOrDefeatLabel

# Initialization
func _ready() -> void:
	# Game scene doesn't start until play is pressed
	game_scene.hide()
	get_tree().paused = true
	
	# Signals
	play_button.pressed.connect(_on_play)
	
	# Wait for everything to be registered
	_ready_deferred.call_deferred()

func _ready_deferred():
	GameManager.player.no_health.connect(_game_end)
	GameManager.opponent.no_health.connect(_game_end)
	GameManager.hud.quit_button.pressed.connect(_game_end)
	

# Go to game scene
func _on_play() -> void:
	game_scene.show()
	GameManager.reset()
	get_tree().paused = false
	menu.hide()

# Return to main menu on game end.
func _game_end() -> void:
	# Show victory or defeat text
	if GameManager.opponent.health == 0:
		victory_defeat_label.text = "Victory"
	else:
		victory_defeat_label.text = "Defeat"
	get_tree().paused = true
	
	# Wait a bit
	await get_tree().create_timer(1.0).timeout
	
	# Return to main menu
	victory_defeat_label.text = ""
	game_scene.hide()
	menu.show()

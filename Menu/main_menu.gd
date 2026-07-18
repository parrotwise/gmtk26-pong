class_name MainMenu extends Node2D

@onready var menu: Control = %Menu
@onready var game_scene: GameScene = %GameScene
@onready var play_button: Button = %Play
@onready var quit_button: Button = %Quit

# Initialization
func _ready() -> void:
	# Game scene doesn't start until play is pressed
	game_scene.hide()
	game_scene.set_process(false)
	
	# Signals
	play_button.pressed.connect(_on_play)
	quit_button.pressed.connect(_on_quit)

# Go to game scene
func _on_play() -> void:
	game_scene.show()
	game_scene.set_process(true)
	menu.hide()

# Quit game
func _on_quit() -> void:
	get_tree().quit()

class_name HUD extends Control

# Export variables
@export var heart_full_texture: Texture2D
@export var heart_empty_texture: Texture2D

# Nodes
@onready var quit_button: TextureButton = %QuitButton
@onready var left_hearts: HBoxContainer = %LeftHearts
@onready var right_hearts: HBoxContainer = %RightHearts

# Initialization
func _ready() -> void:
	# TODO: Register
	
	# Signals
	quit_button.pressed.connect(_on_quit)
	# TODO: Listen for score change
	# some_signal.connect(_update_hearts)
	_update_hearts()


# Set the hearts UI
func _update_hearts() -> void:
	# TODO: Get the score from somewhere
	var hp_left: int = randi_range(0, 3)
	var hp_right: int = randi_range(0, 3)
	
	# Change left heart textures
	for idx in left_hearts.get_child_count():
		var heart: TextureRect = left_hearts.get_child(idx)
		if idx < hp_left:
			heart.texture = heart_full_texture
		else: 
			heart.texture = heart_empty_texture
	
	# Change right heart textures
	for idx in right_hearts.get_child_count():
		var heart: TextureRect = right_hearts.get_child(idx)
		if idx < hp_right:
			heart.texture = heart_full_texture
		else: 
			heart.texture = heart_empty_texture

func _on_quit() -> void:
	# TODO: Go back to main menu instead!
	get_tree().quit()

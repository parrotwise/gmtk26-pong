class_name HUD extends Control

# Export variables
@export var heart_full_texture: Texture2D
@export var heart_empty_texture: Texture2D

# Nodes
@onready var quit_button: TextureButton = %QuitButton
@onready var left_hearts: HBoxContainer = %LeftHearts
@onready var right_hearts: HBoxContainer = %RightHearts

var bar: TextureRect: 
	get: return $Bar

# Initialization
func _ready() -> void:
	# Register
	GameManager.hud = self
	
	# Parrot: The GameScene listens for scores,
	# tells the losing side to take damage, then
	# they do so and tell the HUD to update
	# Agecaf: The Menu scene listens to the quit button

# Reset the HUD
func reset():
	# Change left heart textures
	for heart in left_hearts.get_children():
		(heart as TextureRect).texture = heart_full_texture
	
	# Change right heart textures
	for heart in right_hearts.get_children():
		(heart as TextureRect).texture = heart_full_texture

# Set the hearts UI
func _on_player_health_change(new_health : int):
	# Change left heart textures
	for idx in left_hearts.get_child_count():
		var heart: TextureRect = left_hearts.get_child(idx)
		if idx < new_health:
			heart.texture = heart_full_texture
		else: 
			heart.texture = heart_empty_texture
	
func _on_opponent_health_changed(new_health : int) -> void:
	# Change right heart textures
	for idx in right_hearts.get_child_count():
		var heart: TextureRect = right_hearts.get_child(idx)
		if idx < new_health:
			heart.texture = heart_full_texture
		else: 
			heart.texture = heart_empty_texture

class_name Player
extends CharacterBody2D


func _physics_process(_delta: float) -> void:
	var left_pressed: bool = Input.is_action_pressed('ui_left')
	var right_pressed: bool = Input.is_action_pressed('ui_right')
	var up_pressed: bool = Input.is_action_pressed('ui_up')
	var down_pressed: bool = Input.is_action_pressed('ui_down')
	
	var move_left: int = 1 if left_pressed else 0
	var move_right: int = 1 if right_pressed else 0
	var move_up: int = 1 if up_pressed else 0
	var move_down: int = 1 if down_pressed else 0
	
	self.velocity.x = GameManager.player_speed * (move_right - move_left)
	self.velocity.y = GameManager.player_speed * (move_down - move_up)

	move_and_slide()

	self.position.x = clamp(self.position.x, 0, DisplayServer.window_get_size().x)
	self.position.y = clamp(self.position.y, 0, DisplayServer.window_get_size().y)

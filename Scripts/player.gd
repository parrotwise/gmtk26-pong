class_name Player
extends CharacterBody2D


var collider: CollisionShape2D:
	get: return $Collider


@export var speed: float = 150


func _ready() -> void:
	GameManager.player = self


func _physics_process(_delta: float) -> void:
	var move_up: int = 1 if Input.is_action_pressed('ui_up') else 0
	var move_down: int = 1 if Input.is_action_pressed('ui_down') else 0
	
	velocity.y = speed * (move_down - move_up)
	move_and_slide()
	
	
	

	position.y = clamp(position.y, 0, GameManager.hud.bar.size)

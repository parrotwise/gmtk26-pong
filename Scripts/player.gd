class_name Player
extends CharacterBody2D


signal no_health


@export var speed: float = 150

var collider: CollisionShape2D:
	get: return $Collider
var top_limit: float:
	get: return GameManager.hud.bar.size.y + $Collider.shape.height / 2
var bottom_limit: float:
	get: return get_viewport().size.y - ($Collider.shape.height / 2)

var health: int


func _ready() -> void:
	health = 3

	GameManager.player = self


func _physics_process(_delta: float) -> void:
	var move_up: int = 1 if Input.is_action_pressed('ui_up') else 0
	var move_down: int = 1 if Input.is_action_pressed('ui_down') else 0
	
	velocity.y = speed * (move_down - move_up)
	move_and_slide()
	
	position.y = clamp(position.y, top_limit, bottom_limit)


func lose_health() -> void:
	health -= 1
	
	GameManager.hud._update_hearts()

	if health == 0:
		no_health.emit()

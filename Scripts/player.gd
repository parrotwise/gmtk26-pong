class_name Player
extends CharacterBody2D

signal no_health
signal health_changed(new_health : int)

@export var speed: float = 200

var collider: CollisionShape2D:
	get: return $Collider
var top_limit: float:
	get: return GameManager.hud.bar.size.y + collider.shape.height / 2
var bottom_limit: float:
	get: return get_viewport_rect().size.y - (collider.shape.height / 2)

var health: int

func _ready() -> void:
	reset()
	GameManager.player = self


func _physics_process(_delta: float) -> void:
	var move_up: int = 1 if Input.is_action_pressed('ui_up') else 0
	var move_down: int = 1 if Input.is_action_pressed('ui_down') else 0
	
	velocity.y = speed * (move_down - move_up)
	move_and_slide()
	
	position.y = clamp(position.y, top_limit, bottom_limit)


func lose_health() -> void:
	health -= 1
	
	health_changed.emit(health)

	if health == 0:
		no_health.emit()
		
func reset() -> void:
	health = 5

class_name Opponent
extends StaticBody2D


enum Direction {
	NONE,
	UP,
	DOWN,
}


var position_y_min: float:
	get: return $Collider.shape.height / 2
var position_y_max: float:
	get: return get_viewport().size.y - $Collider.shape.height / 2


@export var speed: float = 200

var direction: Direction
var velocity: float


func _ready() -> void:
	direction = Direction.DOWN
	velocity = 0


func _physics_process(delta: float) -> void:
	if direction == Direction.UP:
		velocity = -speed * delta
	elif direction == Direction.DOWN:
		velocity = speed * delta

	position.y += velocity

	if position.y >= position_y_max:
		direction = Direction.UP
	elif position.y <= position_y_min:
		direction = Direction.DOWN

	position.y = clamp(position.y, position_y_min, position_y_max)

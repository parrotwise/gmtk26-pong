class_name Opponent
extends StaticBody2D


enum Direction {
	NONE,
	UP,
	DOWN,
}


var collider: CollisionShape2D:
	get: return $Collider
var top_limit: float:
	get: return GameManager.hud.bar.size.y + $Collider.shape.height / 2
var bottom_limit: float:
	get: return get_viewport().size.y - ($Collider.shape.height / 2)


@export var speed: float = 200

var direction: Direction
var velocity: float


func _ready() -> void:
	direction = Direction.DOWN
	velocity = 0

	GameManager.opponent = self


func _physics_process(delta: float) -> void:
	if direction == Direction.UP:
		velocity = -speed * delta
	elif direction == Direction.DOWN:
		velocity = speed * delta

	position.y += velocity

	if position.y >= bottom_limit:
		direction = Direction.UP
	elif position.y <= top_limit:
		direction = Direction.DOWN

	position.y = clamp(position.y, top_limit, bottom_limit)

class_name Opponent
extends StaticBody2D


enum Direction {
	NONE,
	UP,
	DOWN,
}

const MARGIN: float = 64.0

var position_y_min: float:
	get: return MARGIN
var position_y_max: float:
	get: return DisplayServer.window_get_size().y - MARGIN

var direction: Direction
var velocity: float

func _ready() -> void:
	direction = Direction.DOWN
	velocity = 0


func _physics_process(delta: float) -> void:
	if direction == Direction.UP:
		velocity = -GameManager.opponent_speed * delta
	elif direction == Direction.DOWN:
		velocity = GameManager.opponent_speed * delta

	position.y += velocity

	if position.y >= position_y_max:
		direction = Direction.UP
	elif position.y <= position_y_min:
		direction = Direction.DOWN

	position.y = clamp(position.y, position_y_min, position_y_max)

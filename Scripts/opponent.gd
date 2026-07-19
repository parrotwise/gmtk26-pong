class_name Opponent
extends StaticBody2D

enum Direction {
	NONE,
	UP,
	DOWN,
}

signal health_changed(new_health: int)
signal no_health


var collider: CollisionShape2D:
	get: return $Collider
var top_limit: float:
	get: return GameManager.hud.bar.size.y + $Collider.shape.height / 2
var bottom_limit: float:
	get: return get_viewport_rect().size.y - ($Collider.shape.height / 2)

@export var speed: float = 250
@export var reaction_time: float = .25

var health: int
var direction: Direction
var velocity: float
var reaction_cooldown: float


func _ready() -> void:
	reset()
	GameManager.opponent = self


func _physics_process(delta: float) -> void:
	if direction == Direction.UP:
		velocity = -speed * delta
	elif direction == Direction.DOWN:
		velocity = speed * delta
	else:
		velocity = 0

	position.y = clampf(position.y + velocity, top_limit, bottom_limit)

	if reaction_cooldown:
		reaction_cooldown = maxf(0, reaction_cooldown - delta)
	
	elif is_instance_valid(GameManager.ball):
		var ball_direction_normalized: float = (
			GameManager.ball.direction
			if GameManager.ball.direction > 0 else
			GameManager.ball.direction + 2 * PI
		)
		var ball_facing_right: bool = ball_direction_normalized < PI / 2 or ball_direction_normalized > PI * 3/2
		
		if ball_facing_right:
			reaction_cooldown = reaction_time

			if GameManager.ball.position.y > (position.y + $Collider.shape.height / 2):
				direction = Direction.DOWN
			elif GameManager.ball.position.y < (position.y - $Collider.shape.height / 2):
				direction = Direction.UP < (position.y + $Collider.shape.height / 2)
			else:
				direction = Direction.NONE


func lose_health() -> void:
	health -= 1
	
	health_changed.emit(health)

	if health == 0:
		no_health.emit()

func reset():
	health = 3
	direction = Direction.DOWN
	velocity = 0
	reaction_cooldown = 0

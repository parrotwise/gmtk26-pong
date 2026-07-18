class_name Ball
extends Area2D


signal bounce
signal bounce_wall
signal bounce_player
signal bounce_opponent
signal score
signal score_player
signal score_opponent

@export var speed: float = 250
@export var pct_speedup_per_bump: int = 2

var position_x_min: float:
	get: return 0
var position_x_max: float:
	get: return get_viewport().size.x
var position_y_min: float:
	get: return GameManager.hud.bar.size.y
var position_y_max: float:
	get: return get_viewport().size.y
var collider_radius: float:
	get: return $Collider.shape.radius

var direction: float # in radians


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	GameManager.ball = self
	
	reset()


func _physics_process(delta: float) -> void:
	position += Vector2(cos(direction), sin(direction)) * speed * delta

	var collision_top: bool = (position.y - collider_radius) <= position_y_min
	var collision_bottom: bool = (position.y + collider_radius) >= position_y_max

	if collision_top or collision_bottom:
		position = Vector2(position.x, clampf(position.y, position_y_min, position_y_max))
		direction = 2*PI - direction
		bounce_wall.emit()
	
	var collision_left: bool = (position.x + collider_radius) <= position_x_min
	var collision_right: bool = (position.x - collider_radius) >= position_x_max
	
	if collision_left:
		set_physics_process(false)
		score.emit()
		score_opponent.emit()
	
	elif collision_right:
		set_physics_process(false)
		score.emit()
		score_player.emit()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		bounce.emit()
		bounce_player.emit()
	
	elif body is Opponent:
		bounce.emit()
		bounce_opponent.emit()
	
	direction = PI - direction
	speed *= 1 + pct_speedup_per_bump / 100.0


func reset() -> void:
	position = get_viewport().size / 2
	direction = RandUtil.randfloat(PI * 3/4, PI * 5/4)
	set_physics_process(true)

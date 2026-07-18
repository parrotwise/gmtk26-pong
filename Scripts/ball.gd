class_name Ball
extends Area2D


@export var speed: float = 250
@export var pct_speedup_per_bump: int = 2

var position_y_min: float:
	get: return GameManager.ui.top_bar.size.y
var position_y_max: float:
	get: return DisplayServer.window_get_size().y
var collider_radius: float:
	get: return $Collider.shape.radius

var direction: float # in radians
var grace_period: int # in physics frames, where paddle collisions are ignored to prevent jitter


func _ready() -> void:
	direction = RandUtil.randfloat(0, 2*PI)
	grace_period = 0

	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position += Vector2(cos(direction), sin(direction)) * speed * delta

	var collision_top: bool = (position.y - collider_radius) <= position_y_min
	var collision_bottom: bool = (position.y + collider_radius) >= position_y_max

	if collision_top or collision_bottom:
		position = Vector2(position.x, clampf(position.y, position_y_min, position_y_max))
		direction = 2*PI - direction
	
	if grace_period:
		grace_period -= 1


func _on_body_entered(_body: Node2D):
	if grace_period:
		return
	
	direction = PI - direction
	speed *= 1 + pct_speedup_per_bump / 100.0
	grace_period += 2

class_name Ball
extends Area2D


enum Direction {
	NONE,
	UP,
	DOWN,
}


signal bounce_sfx
signal bounce_wall
signal bounce_player
signal bounce_opponent
signal score
signal score_player
signal score_opponent


@export var speed: float = 300
@export var pct_speedup_per_bump: int = 5
@export_range(0.0, 2.0, 0.1) var reflection_bias_strength: float = 1.0
@export var pulse_magnitude: float = 1.2
@export var pulse_period: float = 3
@export var base_intensity: float = 1.0
@export var intensity_reset_step: float = 0.1

var player_or_opponent_draw: bool = false

# 180° = reflection direction can be asymptotically vertical
# 170° = reflection direction can be no less than 5° off the vertical
# 0° = reflection directions have no verticality - strictly horizontal
@export_range(120.0, 180.0, 1.0) var valid_reflection_arc_degrees: float = 164.0

var position_x_min: float:
	get: return 0
var position_x_max: float:
	get: return get_viewport_rect().size.x
var position_y_min: float:
	get: return GameManager.hud.bar.size.y
var position_y_max: float:
	get: return get_viewport_rect().size.y
var collider_radius: float:
	get: return $Collider.shape.radius

var intensity: float = 1 # scales glow radius, glow pulse frequency, and ball speed
var direction: float # in radians
var angular_speed: float # in rad/s
var pulse_phase: float


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	GameManager.ball = self


func _process(delta: float) -> void:
	pulse_phase = fmod(pulse_phase + delta, 2 * PI * pulse_period / (4 * intensity))
	$Glow.scale = intensity * sin(pulse_phase * (4 * intensity) / pulse_period) * pulse_magnitude * Vector2.ONE


func _physics_process(delta: float) -> void:
	position += Vector2(cos(direction), sin(direction)) * intensity * speed * delta
	rotation += angular_speed * delta

	var collision_top: bool = (position.y - collider_radius) <= position_y_min
	var collision_bottom: bool = (position.y + collider_radius) >= position_y_max

	if collision_top or collision_bottom:
		position = Vector2(position.x, clampf(position.y, position_y_min, position_y_max))
		angular_speed -= 4*PI - 4*direction
		direction = 2*PI - direction
		bounce_wall.emit()
	
	var collision_left: bool = (position.x + collider_radius) <= position_x_min
	var collision_right: bool = (position.x - collider_radius) >= position_x_max
	
	if collision_left:
		disable()
		score.emit()
		score_opponent.emit()
		player_or_opponent_draw = true
	
	elif collision_right:
		disable()
		score.emit()
		score_player.emit()
		player_or_opponent_draw = false


func _on_body_entered(body: Node2D) -> void:
	var body_motion: Direction = Direction.NONE
	var initial_angle: float = direction

	if body is Player:
		if body.velocity.y > 0:
			body_motion = Direction.DOWN
		elif body.velocity.y < 0:
			body_motion = Direction.UP
		
		bounce_sfx.emit()
		bounce_player.emit()
	
	elif body is Opponent:
		body_motion = body.direction

		bounce_sfx.emit()
		bounce_opponent.emit()
	
	var reflection_bias: float = 0

	# If the colliding body was moving DOWN, the reflection angle may be biased DOWN
	if body_motion == Direction.DOWN:

		# No bias applied if the ball bounced off of the UPPER half
		if position.y <= body.position.y:
			reflection_bias = 0
		
		# The LOWER half interpolates between no bias (collision at the center)
		# and up to 45° DOWN (collision right at the LOWER tip of the collider)
		else:
			var alignment_center: float = body.position.y
			var alignment_tip: float = body.position.y + body.collider.shape.height / 2
			var alignment: float = clampf(position.y, alignment_center, alignment_tip)
			var weight: float = inverse_lerp(alignment_center, alignment_tip, alignment)
			# (alignment - alignment_center) / (alignment_tip - alignment_center)
			reflection_bias = lerpf(0, PI / 4, weight)
	
	# If the colliding body was moving UP, the reflection angle may be biased UP
	elif body_motion == Direction.UP:

		# No bias applied if the ball bounced off of the LOWER half
		if position.y >= body.position.y:
			reflection_bias = 0
		
		# The UPPER half interpolates between no bias (collision at the center)
		# and up to 45° UP (collision right at the UPPER tip of the collider)
		else:
			var alignment_tip: float = body.position.y - body.collider.shape.height / 2
			var alignment_center: float = body.position.y
			var alignment: float = clampf(position.y, alignment_tip, alignment_center)
			var weight: float = inverse_lerp(alignment_tip, alignment_center, alignment)
			# (alignment - alignment_tip) / (alignment_center - alignment_tip)
			
			reflection_bias = lerpf(-PI / 4, 0, weight)
	
	# Reflect the angle of incidence against the normal before applying the bias
	direction = PI - direction
	
	# The bias will be reversed for the Opponent because reflected angles
	# facing LEFT and RIGHT must curl opposite ways to approach DOWN/UP
	direction += reflection_bias * (1 if body is Player else -1) * reflection_bias_strength
	
	#
	# New idea on how to bound the maximum angle.
	#
	
	# We want |x/y| >= lambda, in other words |x| >= lambda * |y|
	var lambda = atan(deg_to_rad(valid_reflection_arc_degrees))
	
	# Get the current direction vector 
	var v: Vector2 = Vector2(1.0, 0.0).rotated(direction)
	
	# Update x so that |x| >= lambda * |y| without changing the sign of x.
	v.x = sign(v.x) * max(abs(v.x), lambda * abs(v.y))
	
	# Get the direction!
	direction = v.angle()
	
	if false:
		# The calculated angle of reflection is clamped to avoid near-vertical directions
		var valid_reflection_arc_radians: float = deg_to_rad(valid_reflection_arc_degrees)
		
		# The quadrant of the angle is determined, as well as a measure of verticality ∈ [0, π]
		var direction_normalized: float = fmod(direction + 2 * PI, 2 * PI)
		var quadrant: int = (
			1 if direction_normalized < (PI / 2) else
			2 if direction_normalized < PI else
			3 if (direction_normalized < PI * 3/2) else
			4
		)
		var direction_verticality = (
			direction_normalized if quadrant == 1 else
			(direction_normalized - PI) if quadrant <= 3 else
			(direction_normalized - 2 * PI)
		)
		
		# If this verticality measure falls outside the valid arc, the delta is used as a correction term
		var direction_verticality_max: float = valid_reflection_arc_radians / 2
		var direction_verticality_min: float = -valid_reflection_arc_radians / 2
		var correction: float = clampf(direction_verticality, direction_verticality_min, direction_verticality_max) - direction_verticality
		
		direction += correction
	
	intensity *= 1 + pct_speedup_per_bump / 100.0
	
	var angle_delta: float = direction - initial_angle
	angular_speed -= 2 * angle_delta


# Maybe make it so the ball starts at the center and it's direction is towards
# whoever lost the previous round? - Zerok
func reset() -> void:
	bounce_sfx.emit()
	
	$ParticleAnchor/Particles.emitting = true
	if player_or_opponent_draw:
		position = GameManager.player.position + Vector2(40.0, 0.0)
		direction = RandUtil.randfloat(PI+PI * 3/4, PI+PI * 5/4)
		if GameManager.player.velocity.y > 0:
			direction += 0.2
		if GameManager.player.velocity.y < 0:
			direction -= 0.2
	else:
		position = GameManager.opponent.position + Vector2(-40.0, 0.0)
		direction = RandUtil.randfloat(PI * 3/4, PI * 5/4)
	angular_speed = RandUtil.randfloat(PI, 2 * PI)
	set_physics_process(true)
	intensity = base_intensity + intensity_reset_step * (6 - GameManager.player.health - GameManager.opponent.health)


func disable() -> void:
	$ParticleAnchor/Particles.emitting = false
	position = -get_viewport_rect().size
	set_physics_process(false)

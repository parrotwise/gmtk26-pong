class_name CoolText extends TextureRect

@export var T = 5.0
@export var gradient: Gradient
var t = 0.0

func _ready() -> void:
	# Register
	GameManager.cool_text = self
	t = 0.0

func reset() -> void:
	t = 0.0

func _process(delta: float) -> void:
	t += delta
	modulate = gradient.sample(clampf(t / T, 0.0, 1.0))

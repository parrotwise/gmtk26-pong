extends CanvasLayer

signal faded_in_black
signal faded_out_black


@export var fade_duration: float = 0.5
@export var color: Color = Color.BLACK

@onready var color_rect: ColorRect = $ColorRect

### CHANGE IF YOU WANT SOMETHING OTHER THAN FADE - Zerok

func _ready() -> void:
	color_rect.color = color
	color_rect.modulate.a = 0.0

func fade_in_black(duration: float = fade_duration) -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, duration)
	await tween.finished
	faded_in_black.emit()
	
func fade_out_black(duration: float = fade_duration) -> void:
	color_rect.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	await tween.finished
	faded_out_black.emit()

class_name GameScene extends Control


func _ready() -> void:
	# Placeholder: Quietly reset the board so we can keep experimenting
	GameManager.ball.score.connect(
		func() -> void:
			get_tree().create_timer(2).timeout.connect(GameManager.ball.reset)
	)

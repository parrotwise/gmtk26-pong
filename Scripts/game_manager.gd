extends Node


var hud: HUD
var ball: Ball
var player: Player
var opponent: Opponent


func _on_win_game() -> void:
	Debug.info('And there was much rejoicing.')


func _on_lose_game() -> void:
	Debug.info('Perhaps next time. ¯\\_(ツ)_/¯')


func _on_score() -> void:
	# Placeholder: Quietly reset the board so we can keep experimenting
	get_tree().create_timer(2).timeout.connect(ball.reset)

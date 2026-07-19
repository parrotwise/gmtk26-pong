extends Node

var hud: HUD
var ball: Ball
var player: Player
var opponent: Opponent

# Reset the state to the start of the game
func reset() -> void:
	# TODO: Payer and opponent positions?
	player.reset()
	opponent.reset()
	ball.reset()
	
func _on_win_game() -> void:
	Debug.info('And there was much rejoicing.')


func _on_lose_game() -> void:
	Debug.info('Perhaps next time. ¯\\_(ツ)_/¯')

func _on_score() -> void:
	# Placeholder: Quietly reset the board so we can keep experimenting
	get_tree().create_timer(2).timeout.connect(ball.reset)

class_name GameScene extends Control

func _ready() -> void:
	GameManager.ball.score_player.connect(GameManager.opponent.lose_health)
	GameManager.ball.score_opponent.connect(GameManager.player.lose_health)
	
	GameManager.player.health_changed.connect(GameManager.hud._on_player_health_change)
	GameManager.opponent.health_changed.connect(GameManager.hud._on_opponent_health_changed)
	
	GameManager.ball.score.connect(GameManager._on_score)
	GameManager.player.no_health.connect(GameManager._on_lose_game)
	GameManager.opponent.no_health.connect(GameManager._on_win_game)

	GameManager.ball.bounce_sfx.connect(AudioManager.play_sfx.bind('Bounce'))
	GameManager.ball.score.connect(AudioManager.play_sfx.bind('Score'))

# Helper functions (Made these to make the code more self-documenting)
func pause_game_objects() -> void:
	process_mode = PROCESS_MODE_DISABLED

func unpause_game_objects() -> void:
	process_mode = PROCESS_MODE_INHERIT

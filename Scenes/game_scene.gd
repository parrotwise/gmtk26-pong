class_name GameScene extends Control

func _ready() -> void:
	GameManager.ball.score_player.connect(GameManager.opponent.lose_health)
	GameManager.ball.score_opponent.connect(GameManager.player.lose_health)
	
	GameManager.player.health_changed.connect(GameManager.hud._on_player_health_change)
	GameManager.opponent.health_changed.connect(GameManager.hud._on_opponent_health_changed)
	
	GameManager.ball.score.connect(GameManager._on_score)
	GameManager.player.no_health.connect(GameManager._on_lose_game)
	GameManager.opponent.no_health.connect(GameManager._on_win_game)

	GameManager.ball.bounce.connect(AudioManager.play_sfx.bind('Bounce'))
	GameManager.ball.score.connect(AudioManager.play_sfx.bind('Score'))

	AudioManager.play_music('Intro')

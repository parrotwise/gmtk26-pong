class_name MainMenu extends Node2D

@onready var menu: Control = %Menu
@onready var game_scene: GameScene = %GameScene
@onready var play_button: Button = %Play
@onready var victory_defeat_label: Label = %VictoryOrDefeatLabel
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider

# Initialization
func _ready() -> void:
	# Game scene doesn't start until play is pressed
	game_scene.hide()
	get_tree().paused = true
	
	# Signals
	play_button.pressed.connect(_on_play)
	music_slider.value_changed.connect(_set_music_volume)
	sfx_slider.value_changed.connect(_set_sfx_volume)
	_set_music_volume(80.0)
	_set_sfx_volume(80.0)
	
	# Wait for everything to be registered
	_ready_deferred.call_deferred()
	

func _ready_deferred():
	GameManager.player.no_health.connect(_game_end)
	GameManager.opponent.no_health.connect(_game_end)
	GameManager.hud.quit_button.pressed.connect(_game_end)
	

# Go to game scene
func _on_play() -> void:
	play_button.disabled = true
	get_tree().paused = false 
	
	game_scene.pause_game_objects()
	
	await Transition.fade_in_black()
	
	game_scene.show()
	GameManager.reset()
	menu.hide()
	
	game_scene.unpause_game_objects()
	
	AudioManager.play_music("Intro")
	
	await Transition.fade_out_black()
	
	play_button.disabled = false

# Return to main menu on game end.
func _game_end() -> void:
	
	AudioManager.stop_music(true, 2.0)
	
	# Show victory or defeat text
	if GameManager.opponent.health == 0:
		victory_defeat_label.text = "Victory"
	else:
		victory_defeat_label.text = "Defeat"
	
	game_scene.pause_game_objects()
	
	victory_defeat_label.modulate.a = 0.0
	victory_defeat_label.show()
	
	var fade_duration = 0.4
	
	# Fade in the label
	var tween = create_tween()
	tween.tween_property(victory_defeat_label, "modulate:a", 1.0, fade_duration)
	await tween.finished
	
	await get_tree().create_timer(1.0).timeout
	
	# return to menu with the fade to black transition
	await Transition.fade_in_black(0.5)
	
	victory_defeat_label.text = ""
	game_scene.hide()
	menu.show()
	
	await Transition.fade_out_black(0.5)

# Set the Volume
func _set_music_volume(value: float):
	print(value)
	AudioServer.set_bus_mute(1, value <= 5.0)
	AudioServer.set_bus_volume_linear(1, value / 100.0)
	

func _set_sfx_volume(value: float):
	print(value)
	
	AudioServer.set_bus_mute(2, value <= 5.0)
	AudioServer.set_bus_volume_linear(2, value / 200.0)

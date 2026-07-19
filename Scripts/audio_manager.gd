extends Node


@onready var sfx_bounce: AudioStream = preload('res://Audio/bounce_placeholder.wav')
@onready var sfx_score: AudioStream = preload('res://Audio/score_placeholder.wav')

@onready var music_loop: AudioStream = preload('res://Audio/main_theme.wav')
@onready var music_intro: AudioStream = preload('res://Audio/main_theme_intro.wav')
@onready var music_outro: AudioStream = preload('res://Audio/main_theme_outro.wav')


func _ready() -> void:
	var sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()
	sfx_player.name = 'SFXPlayer'
	add_child(sfx_player)

	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	music_player.name = 'MusicPlayer'
	add_child(music_player)


func play(sfx: AudioStream, volume: float = 0.5) -> void:
	if not has_node('SFXPlayer') or $SFXPlayer.playing:
		return
	
	$SFXPlayer.stream = sfx
	$SFXPlayer.volume_db = linear_to_db(volume)
	$SFXPlayer.pitch_scale = RandUtil.randfloat(0.8, 1.2)

	$SFXPlayer.play()


func start_music(volume: float = 0.5) -> void:
	if not has_node('MusicPlayer') or $MusicPlayer.playing:
		return
	
	$MusicPlayer.stream = music_intro
	$MusicPlayer.volume_linear = volume
	
	$MusicPlayer.finished.connect(
		func() -> void:
			$MusicPlayer.stream = music_loop
			$MusicPlayer.play()
	)

	$MusicPlayer.play()


func stop_music(fade_out: bool = true, fade_out_duration: float = 2.0) -> void:
	if not has_node('MusicPlayer') or not $MusicPlayer.playing:
		return
	
	if fade_out:
		Debug.warning('1')
		var tween: Tween = get_tree().create_tween()
		tween.tween_property($MusicPlayer, 'volume_linear', 0, fade_out_duration)
		tween.finished.connect(stop_music.bind(false))
	
	else:
		Debug.warning('2')
		for connection: Dictionary in $MusicPlayer.finished.get_connections():
			$MusicPlayer.finished.disconnect(connection['callable'])
		
		$MusicPlayer.stop()

extends Node


var sfx_player_template: PackedScene = preload('res://Scenes/sfx_player.tscn')
var music_player_template: PackedScene = preload('res://Scenes/music_player.tscn')


func _ready() -> void:
	add_child(sfx_player_template.instantiate())
	add_child(music_player_template.instantiate())


func play_sfx(clip_name: StringName, volume: float = 0.5) -> void:
	if not has_node('SFXPlayer'):
		return
	
	$SFXPlayer.volume_linear = volume
	$SFXPlayer.pitch_scale = RandUtil.randfloat(0.8, 1.2)
	
	if not $SFXPlayer.playing:
		$SFXPlayer.play()

	$SFXPlayer.get_stream_playback().switch_to_clip_by_name(clip_name)


func play_music(clip_name: StringName = 'Intro', volume: float = 0.5) -> void:
	if not has_node('MusicPlayer'):
		return

	$MusicPlayer.volume_linear = volume
	
	if not $MusicPlayer.playing:
		$MusicPlayer.play()
	
	$MusicPlayer.get_stream_playback().switch_to_clip_by_name(clip_name)


func stop_music(fade_out: bool = true, fade_out_duration: float = 2.0) -> void:
	if not has_node('MusicPlayer') or not $MusicPlayer.playing:
		return
	
	if fade_out:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property($MusicPlayer, 'volume_linear', 0, fade_out_duration)
		tween.finished.connect(stop_music.bind(false))
	
	else:
		for connection: Dictionary in $MusicPlayer.finished.get_connections():
			$MusicPlayer.finished.disconnect(connection['callable'])
		
		$MusicPlayer.stop()

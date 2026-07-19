extends Node


@onready var sfx_bounce: AudioStream = preload('res://Audio/bounce_placeholder.wav')
@onready var sfx_score: AudioStream = preload('res://Audio/score_placeholder.wav')


func _ready() -> void:
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.name = 'Player'
	add_child(player)


func play(sfx: AudioStream, volume: float = 0.5) -> void:
	if not has_node('Player') or $Player.playing:
		return
	
	$Player.stream = sfx
	$Player.volume_db = linear_to_db(volume)
	$Player.pitch_scale = RandUtil.randfloat(0.8, 1.2)

	$Player.play()

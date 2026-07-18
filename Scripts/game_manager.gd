extends Node


const INITIAL_BALL_SPEED: float = 240.0

var ball_speed: float
var player_speed: float:
	get: return DisplayServer.window_get_size().y / 4.0
var opponent_speed: float:
	get: return DisplayServer.window_get_size().y / 3.0


func _ready() -> void:
	ball_speed = INITIAL_BALL_SPEED

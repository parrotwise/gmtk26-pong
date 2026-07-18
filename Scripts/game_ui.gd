class_name GameUI
extends Control


var top_bar: Panel:
	get: return $TopBar


func _ready() -> void:
	$TopBar/QuitButton.pressed.connect(_on_quit_button_pressed)


func _on_quit_button_pressed() -> void:
	get_tree().quit()

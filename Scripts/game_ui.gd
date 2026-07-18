class_name GameUI
extends Control


func _ready() -> void:
	$TopBar/QuitButton.pressed.connect(_on_quit_button_pressed)


func _on_quit_button_pressed() -> void:
	get_tree().quit()

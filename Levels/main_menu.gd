extends CanvasLayer

const GAME := preload("res://Levels/game.tscn")

@onready var play_button: Button = %PlayButton

func _ready() -> void:
	play_button.grab_focus()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(GAME)

extends CanvasLayer

const GAME := preload("res://Levels/game.tscn")

@onready var play_button: Button = %PlayButton
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var transition: CanvasLayer = $Transition


func _ready() -> void:
	play_button.grab_focus()

func _on_play_button_pressed() -> void:
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("start")
	await get_tree().create_timer(2.0).timeout
	transition.fade_to_black()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_packed(GAME)

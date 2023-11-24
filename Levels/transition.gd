extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	fade_to_normal()
	
func fade_to_normal() -> void:
	animation_player.play("fade_to_normal")

func fade_to_black() -> void:
	animation_player.play("fade_to_black")

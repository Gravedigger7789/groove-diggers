extends Node2D

@onready var torso: AnimatedSprite2D = $Torso
@onready var legs: AnimatedSprite2D = $Legs

func _ready() -> void:
	legs.play("run")
	torso.play("run")
	sync_legs_with_torso()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("hit"):
		torso.play("hit-up")
	sync_legs_with_torso()

func _on_animated_sprite_2d_animation_looped() -> void:
	if torso.animation.contains("hit"):
		var current_frame := legs.get_frame()
		var current_progress := legs.get_frame_progress()
		torso.play("run")
		torso.set_frame_and_progress(current_frame, current_progress)

func sync_legs_with_torso() -> void:
	if torso.animation == ("run"):
		var current_frame := legs.get_frame()
		var current_progress := legs.get_frame_progress()
		torso.set_frame_and_progress(current_frame, current_progress)

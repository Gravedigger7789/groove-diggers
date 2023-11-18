extends Node2D

@onready var torso: AnimatedSprite2D = $Torso
@onready var legs: AnimatedSprite2D = $Legs

var top_position := -175.0
var middle_position := -100.0
var bottom_position := 0.0

var up_click_time := 0.0
var down_click_time := 0.0
var click_tolerance := 200

func _ready() -> void:
	top_position += position.y
	middle_position += position.y
	bottom_position += position.y
	legs.play("run")
	torso.play("run")
	sync_legs_with_torso()

func _process(_delta: float) -> void:
	var now := Time.get_ticks_msec()

	if Input.is_action_just_pressed("hit_up"):
		if down_click_time > 0:
			if now - down_click_time < click_tolerance:
				torso.play("hit-up")
				position.y = middle_position
		else:
			torso.play("hit-up")
			position.y = top_position
		up_click_time = now

	if Input.is_action_just_released("hit_up"):
		up_click_time = 0.0

	if Input.is_action_just_pressed("hit_down"):
		if up_click_time > 0:
			if now - up_click_time < click_tolerance:
				torso.play("hit-up")
				position.y = middle_position
		else:
			torso.play("hit-down")
			position.y = bottom_position
		down_click_time = now

	if Input.is_action_just_released("hit_down"):
		down_click_time = 0.0

	sync_legs_with_torso()

func _on_animated_sprite_2d_animation_looped() -> void:
	if torso.animation.contains("hit"):
		var current_frame := legs.get_frame()
		var current_progress := legs.get_frame_progress()
		torso.play("run")
		torso.set_frame_and_progress(current_frame, current_progress)
		position.y = bottom_position

func sync_legs_with_torso() -> void:
	if torso.animation == ("run"):
		var current_frame := legs.get_frame()
		var current_progress := legs.get_frame_progress()
		torso.set_frame_and_progress(current_frame, current_progress)

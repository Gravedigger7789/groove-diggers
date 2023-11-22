extends Node2D

@onready var torso: AnimatedSprite2D = $Torso
@onready var legs: AnimatedSprite2D = $Legs
@onready var torch: PointLight2D = $Torch
@onready var fall_timer: Timer = $FallTimer

var top_position := -100.0
var middle_position := -40.0
var bottom_position := 0.0

var up_click_time := 0.0
var down_click_time := 0.0
var click_tolerance := 200

var health := 100
var dead := false
signal health_changed(health: int)
signal death

func _ready() -> void:
	health_changed.emit(health)
	top_position += position.y
	middle_position += position.y
	bottom_position += position.y
	legs.play("run")
	torso.play("run")
	sync_legs_with_torso()

func _process(_delta: float) -> void:
	var now := Time.get_ticks_msec()

	if Input.is_action_pressed("hit_up"):
		if down_click_time > 0:
			if now - down_click_time < click_tolerance:
				torso.play("hit-mid")
				if legs.animation != ("jump"):
					legs.play("jump")
				position.y = middle_position
				fall_timer.start()
		else:
			torso.play("hit-up")
			if legs.animation != ("jump"):
				legs.play("jump")
			position.y = top_position
			fall_timer.start()
		up_click_time = now

	if !Input.is_action_pressed("hit_up"):
		up_click_time = 0.0

	if Input.is_action_pressed("hit_down"):
		if up_click_time > 0:
			if now - up_click_time < click_tolerance:
				torso.play("hit-mid")
				if legs.animation != ("jump"):
					legs.play("jump")
				position.y = middle_position
				fall_timer.start()
		else:
			torso.play("hit-down")
			position.y = bottom_position
		down_click_time = now

	if !Input.is_action_pressed("hit_down"):
		down_click_time = 0.0

	if position.y == bottom_position && legs.animation != ("run"):
		legs.play("run")
	sync_legs_with_torso()

func sync_legs_with_torso() -> void:
	if torso.animation == ("run") && legs.animation == ("run"):
		var current_frame := legs.get_frame()
		var current_progress := legs.get_frame_progress()
		torso.set_frame_and_progress(current_frame, current_progress)

func damage(value: int) -> void:
	if !dead:
		health -= value
		health_changed.emit(health)
		if health <= 0:
			dead = true
			set_process(false)
			set_process_input(false)
			position.y = bottom_position
			torso.play("death")
			legs.stop()
			legs.hide()
			var tween := create_tween()
			tween.tween_property(torch, "energy", 0, 1.0)
			death.emit()
		elif !torso.animation.contains("damage"):
			torso.play("damage")

func _on_torso_animation_finished() -> void:
	if !dead && (torso.animation.contains("hit") || torso.animation.contains("damage")):
		torso.play("run")
		sync_legs_with_torso()

func _on_fall_timer_timeout() -> void:
	position.y = bottom_position

func celebrate() -> void:
	set_process(false)
	set_process_input(false)
	position.y = bottom_position
	torso.play("celebrate")
	legs.stop()
	legs.hide()
	var tween := create_tween()
	tween.tween_property(torch, "energy", 0, 1.0)

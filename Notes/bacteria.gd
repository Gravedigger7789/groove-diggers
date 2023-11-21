extends Note2D

@onready var trailing_line_target := SPAWN_X

var check_if_holding := false
var line_color := Color.GOLD

func hit(hit_position: float) -> void:
	speed = 0
	var hit_quality := calculate_hit_quality(hit_position, Time.get_unix_time_from_system())
	note_hit.emit(100 * hit_quality, hit_quality)
	quality_label.text = Global.Quality.keys()[hit_quality]
	animation_player.play("hit")
	check_if_holding = true

func _process(_delta: float) -> void:
	var bacteria := get_tree().get_nodes_in_group("bacteria")
	bacteria.erase(self)
	if bacteria.size() > 0:
		if current_beat == 0:
			trailing_line_target = bacteria[0].position.x - global_position.x
			if trailing_line_target <= 0:
				bacteria[0].queue_free()
				animation_player.play("collect")
			queue_redraw()
	elif current_beat == 1:
		queue_free()
	if check_if_holding:
		if Input.is_action_just_released("hit_down"):
			speed = (target_position - SPAWN_X) / target_time
			line_color = Color.RED
			queue_redraw()

func _draw() -> void:
	if current_beat == 0:
		draw_line(Vector2.ZERO, Vector2(trailing_line_target, 0), line_color, 24)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		animation_player.play("spin")

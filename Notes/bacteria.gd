extends Note2D

@onready var trailing_line_target := SPAWN_X

var check_if_holding := false
var found_bacteria_in_lane := false
var hit_quality := Global.Quality.OK
var line_color := Color.GOLD

func hit(hit_position: float) -> void:
	speed = 0
	hit_quality = calculate_hit_quality(hit_position, Time.get_unix_time_from_system())
	note_hit.emit(100 * hit_quality, hit_quality)
	quality_label.text = Global.Quality.keys()[hit_quality]
	animation_player.play("hit")
	check_if_holding = true

func _process(_delta: float) -> void:
	var bacteria := get_tree().get_nodes_in_group("bacteria")
	bacteria.erase(self)
	found_bacteria_in_lane = false
	for node in bacteria:
		if node.current_lane == current_lane:
			found_bacteria_in_lane = true
			if current_beat == 0:
				trailing_line_target = node.position.x - global_position.x
				if trailing_line_target <= 0:
					node.queue_free()
					note_hit.emit(100 * hit_quality, hit_quality)
					animation_player.play("collect")
				queue_redraw()
	if !found_bacteria_in_lane && current_beat == 1:
		queue_free()
	if check_if_holding:
		var action := "hit_up"
		if current_lane == Global.Lane.BOTTOM:
			action = "hit_down"
		if Input.is_action_just_released(action):
			speed = (target_position - SPAWN_X) / target_time
			line_color = Color.RED
			queue_redraw()

func _draw() -> void:
	if current_beat == 0:
		draw_line(Vector2.ZERO, Vector2(trailing_line_target, 0), line_color, 24)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		animation_player.play("spin")

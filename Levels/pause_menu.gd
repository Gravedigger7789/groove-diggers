extends CanvasLayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		hide()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	hide()
	get_tree().reload_current_scene()

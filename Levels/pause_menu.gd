extends CanvasLayer

@onready var resume: Button = %Resume

func _ready() -> void:
	resume.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		unpause()

func _on_restart_pressed() -> void:
	unpause()
	get_tree().reload_current_scene()

func _on_resume_pressed() -> void:
	unpause()

func unpause() -> void:
	get_tree().paused = false
	hide()

func _on_visibility_changed() -> void:
	if resume:
		resume.grab_focus()

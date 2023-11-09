extends Node2D

var current_note := {}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hit"):
		#print (current_note.keys())
		for note: String in current_note.keys():
			current_note[note].queue_free()
			current_note.erase(note)

func _on_area_2d_area_entered(area: Area2D) -> void:
	current_note[get_node(area.get_path()).name] = area


func _on_area_2d_area_exited(area: Area2D) -> void:
	current_note.erase(get_node(area.get_path()).name)

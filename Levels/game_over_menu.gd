extends CanvasLayer

@onready var score_label: Label = %Score
@onready var combo_label: Label = %Combo
@onready var main_menu: Button = %MainMenu
@onready var restart: Button = %Restart

func update_score(value: int) -> void:
	score_label.text = "Gold: " + str(value)

func update_combo(value: int) -> void:
	combo_label.text = "Max Combo: " + str(value)

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

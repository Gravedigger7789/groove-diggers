extends CanvasLayer

var MAIN_MENU := load("res://Levels/main_menu.tscn")

@onready var score_label: Label = %Score
@onready var combo_label: Label = %Combo
@onready var restart: Button = %Restart
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	restart.grab_focus()

func update_score(value: int) -> void:
	score_label.text = "Gold: " + str(value)

func update_combo(value: int) -> void:
	combo_label.text = "Max Combo: " + str(value)

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_visibility_changed() -> void:
	if restart:
		restart.grab_focus()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)

func play_success() -> void:
	show()
	animation_player.play("success")

func play_failure() -> void:
	show()
	animation_player.play("failure")

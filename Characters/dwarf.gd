extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("hit"):
		#animated_sprite_2d.animation = "hit"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("hit"):
		animated_sprite_2d.animation = "hit-up"


func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite_2d.animation.contains("hit"):
		animated_sprite_2d.animation = "run"

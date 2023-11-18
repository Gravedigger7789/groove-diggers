extends Node2D

var speed := 0.0

@onready var parallax_background: ParallaxBackground = $ParallaxBackground

func _physics_process(delta: float) -> void:
	# Scroll background
	parallax_background.scroll_offset.x += speed * delta

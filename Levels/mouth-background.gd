extends Node2D

@onready var parallax_background: ParallaxBackground = $ParallaxBackground

func _physics_process(delta: float) -> void:
	# Scroll background
	parallax_background.scroll_offset.x -= 512 * delta

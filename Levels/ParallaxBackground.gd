extends ParallaxBackground

func _physics_process(delta: float) -> void:
	# Scroll background
	scroll_offset.x -= 520 * delta

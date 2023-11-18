extends Node2D

var speed := 0.0

@onready var background: ParallaxBackground = $Background
@onready var foreground: ParallaxBackground = $Foreground

func _physics_process(delta: float) -> void:
	# Scroll background
	background.scroll_offset.x += speed * delta
	foreground.scroll_offset.x += speed * delta

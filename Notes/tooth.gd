extends Area2D

# verticle line position + half object size
const TARGET_X = 256 + 64
# screen res + object size
const SPAWN_X := 1152 + 128
const DISTANCE_TO_TARGET = TARGET_X - SPAWN_X
const TOP_SPAWN = Vector2(SPAWN_X, 162)
const BOTTOM_SPAWN = Vector2(SPAWN_X, 486)
const SECONDS_TO_TARGET = 2.0

@onready var speed := DISTANCE_TO_TARGET / SECONDS_TO_TARGET

#@onready var time_start := Time.get_unix_time_from_system()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_position := randi() % 2
	if random_position <= 0:
		position = TOP_SPAWN
	else:
		position = BOTTOM_SPAWN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta
	#if position.x <= TARGET_X:
		#print("reached target, ", Time.get_unix_time_from_system() - time_start)
		#queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

extends Area2D

# screen res + half object size
const SPAWN_X := 640 + 32
const TOP_SPAWN = Vector2(SPAWN_X, 80)
const BOTTOM_SPAWN = Vector2(SPAWN_X, 280)
const SECONDS_TO_TARGET = 2.0


var speed : float

@onready var time_start := Time.get_unix_time_from_system()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func setup_note(lane: int, screen_time: float, target_position: float) -> void:
	speed = (target_position - SPAWN_X) / screen_time
	match lane:
		0:
			position = TOP_SPAWN
		1:
			position = BOTTOM_SPAWN
		_:
			queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x += speed * delta
	#position.x = round(position.x)
	#if position.x <= TARGET_X:
		#print("reached target ", Time.get_unix_time_from_system() - time_start)
		#print(position.x)
		#queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func hit(hit_position: float) -> void:
	print("alive for ", Time.get_unix_time_from_system() - time_start)
	queue_free()

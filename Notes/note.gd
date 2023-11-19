extends Area2D

# screen res + half object size
const SPAWN_X := 640 + 32
const TOP_SPAWN = Vector2(SPAWN_X, 80)
const BOTTOM_SPAWN = Vector2(SPAWN_X, 280)
const SECONDS_TO_TARGET = 2.0

var speed : float
var target_position: float
var target_missed_offset := 64

@onready var time_start := Time.get_unix_time_from_system()

signal note_hit(value: int)
signal note_missed(value: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func setup_note(lane: int, screen_time: float, target_pos: float) -> void:
	target_position = target_pos
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
	if position.x <= target_position - target_missed_offset:
		note_missed.emit(5)
		queue_free()
	#position.x = round(position.x)
	#if position.x <= TARGET_X:
		#print("reached target ", Time.get_unix_time_from_system() - time_start)
		#print(position.x)
		#queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func hit(hit_position: float) -> void:
	print("alive for ", Time.get_unix_time_from_system() - time_start)
	note_hit.emit(100)
	queue_free()

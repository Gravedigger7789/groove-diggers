extends Area2D

@export var beat_textures: Array[Texture] = []

# screen res + half object size
const SPAWN_X := 640 + 32
const TOP_SPAWN = Vector2(SPAWN_X, 80)
const BOTTOM_SPAWN = Vector2(SPAWN_X, 280)
const SECONDS_TO_TARGET = 2.0

var speed : float
var target_position: float
var target_missed_offset := 64
var colllected := false
var current_beat: Global.BEAT

@onready var time_start := Time.get_unix_time_from_system()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


signal note_hit(value: int)
signal note_missed(value: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = beat_textures[current_beat]

func setup_note(lane: int, screen_time: float, target_pos: float, beat: Global.BEAT) -> void:
	target_position = target_pos
	speed = (target_position - SPAWN_X) / screen_time
	current_beat = beat
	match lane:
		Global.LANE.TOP:
			position = TOP_SPAWN
		Global.LANE.BOTTOM:
			position = BOTTOM_SPAWN
		_:
			queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x += speed * delta
	if !colllected && position.x <= target_position - target_missed_offset:
		note_missed.emit(5)
		queue_free()

	#if position.x <= target_position && !colllected:
		#hit(position.x)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func hit(hit_position: float) -> void:
	print("alive for ", Time.get_unix_time_from_system() - time_start)
	note_hit.emit(100)
	colllected = true
	animation_player.play("collect")

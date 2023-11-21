extends Area2D

@export var beat_textures: Array[Texture] = []

# screen res + half object size
const SPAWN_X := 640 + 32
const TOP_SPAWN = Vector2(SPAWN_X, 80)
const BOTTOM_SPAWN = Vector2(SPAWN_X, 280)

var speed : float
var target_position: float
var target_missed_offset := 64
var target_time: float
var colllected := false
var current_beat: Global.Beat

@onready var time_start := Time.get_unix_time_from_system()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal note_hit(value: int, quality: Global.Quality)
signal note_missed(value: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if beat_textures.size() < current_beat + 1:
		current_beat = Global.Beat.FULL
	sprite_2d.texture = beat_textures[current_beat]

func setup_note(lane: int, screen_time: float, target_pos: float, beat: Global.Beat) -> void:
	target_position = target_pos
	target_time = screen_time
	speed = (target_position - SPAWN_X) / target_time
	current_beat = beat
	match lane:
		Global.Lane.TOP:
			position = TOP_SPAWN
		Global.Lane.BOTTOM:
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
		#hit(position.x - 32)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func hit(hit_position: float) -> void:
	var hit_position_center: float = hit_position + (collision_shape_2d.shape.size.x / 2)
	var time_alive := Time.get_unix_time_from_system() - time_start
	var percent_error_time: float = (abs(time_alive - target_time) / target_time) * 100
	var percent_error_position: float = (abs(hit_position_center - target_position) / target_position) * 100
	var hit_quality := Global.Quality.OK
	if percent_error_time < 2.5 || percent_error_position < 5:
		hit_quality = Global.Quality.PERFECT
	elif percent_error_time < 5 || percent_error_position < 10:
		hit_quality = Global.Quality.GREAT
	elif percent_error_time < 10 || percent_error_position < 25:
		hit_quality = Global.Quality.GOOD
	note_hit.emit(100 * hit_quality, hit_quality)
	colllected = true
	animation_player.play("collect")

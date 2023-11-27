extends Node2D

@onready var top_note: RayCast2D = $TopNote
@onready var bottom_note: RayCast2D = $BottomNote

signal missed

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("hit_up"):
		check_for_collision(top_note)
	if Input.is_action_just_pressed("hit_down"):
		check_for_collision(bottom_note)

func check_for_collision(raycast: RayCast2D) -> void:
	if raycast.is_colliding():
		var collision_distance := get_raycast_collision_distance(raycast)
		var collider := raycast.get_collider()
		if collider.has_method("hit"):
			collider.hit(collision_distance)
		raycast.add_exception(collider)
		raycast.force_raycast_update()
	else:
		raycast.clear_exceptions()
		missed.emit()

func get_raycast_collision_distance(raycast: RayCast2D) -> float:
	var collision_distance := -1.0
	if raycast.is_colliding():
		var collision_point := raycast.get_collision_point()
		collision_distance = collision_point.x
	return collision_distance
	

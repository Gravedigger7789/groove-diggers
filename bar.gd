extends Node2D

@onready var top_note: RayCast2D = $TopNote
@onready var bottom_note: RayCast2D = $BottomNote

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("hit_up"):
		if top_note.is_colliding():
			var collision_distance := get_raycast_collision_distance(top_note)
			var collider := top_note.get_collider()
			if collider.has_method("hit"):
				collider.hit(collision_distance)
	if Input.is_action_just_pressed("hit_down"):
		if bottom_note.is_colliding():
			var collision_distance := get_raycast_collision_distance(bottom_note)
			print(collision_distance)
			var collider := bottom_note.get_collider()
			if collider.has_method("hit"):
				collider.hit(collision_distance)

func get_raycast_collision_distance(raycast: RayCast2D) -> float:
	var collision_distance := -1.0
	if raycast.is_colliding():
		var origin := raycast.global_transform.origin
		var collision_point := raycast.get_collision_point()
		collision_distance = origin.distance_to(collision_point)
	return collision_distance
	

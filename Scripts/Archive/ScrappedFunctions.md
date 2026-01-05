func handle_movement(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	#if Input.is_action_just_pressed("Jump") and is_on_floor():
		#velocity.y = jump_height

	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	#var mesh_rot = mesh_instance.global_rotation.y 
	#var cam_rot = camera_pivot.global_rotation.y
	#if abs(mesh_rot - cam_rot) > auto_turn_deadzone or direction:
		#mesh_instance.global_rotation.y = move_toward(mesh_rot, cam_rot, 0.25)


func follow(_delta: float) -> void:
	var goto_pos := partner.global_position
	var distance = (goto_pos - global_position).length()
	if distance > min_distance:
		global_position = global_position.move_toward(goto_pos, follow_speed)
	if not is_on_floor():
		velocity += get_gravity() * _delta


var nearest_body: Node3D = bodies[0]
		var nearest_distance = abs(nearest_body.global_position - global_position).length()
		bodies.pop_at(0)
		for body in bodies:
			var new_distance = abs(body.global_position - global_position).length()
			if new_distance < nearest_distance:
				nearest_body = body
				nearest_distance = new_distance



if timer_done:
		timer_done = false
		start_timer(time_in_state, func(): timer_done = true)
		should_move = true
	elif timer_done: 
		should_move = false

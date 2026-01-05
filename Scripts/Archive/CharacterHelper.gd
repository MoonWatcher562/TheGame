extends Script
class_name CharacterHelper

static func calculate_movement_vector(character: CharacterBody3D, pivot_obj: Node3D, partner: CharacterBody3D, speed: float, jump_height: float, delta: float, min_distance: float, apply_gravity: bool = true, is_ai: bool = false) -> Vector3:
	var velocity: Vector3 = character.velocity
	if not character.is_on_floor() and apply_gravity:
		velocity += character.get_gravity() * delta
	
	if Input.is_action_just_pressed("Jump") and character.is_on_floor() and not is_ai:
		velocity.y = jump_height
	
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction: Vector3
	var should_move: bool
	
	if is_ai: 
		direction = (partner.global_position - character.global_position).normalized()
		var distance = abs(partner.global_position - character.global_position).length()
		should_move = distance < min_distance
	else:
		direction = (pivot_obj.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		should_move = true
	
	if direction and should_move:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	return velocity


static func handle_mouse_camera(event: InputEventMouseMotion, camera_pivot: Node3D, mouse_sensitivity: float, pitch: float) -> void:
	var tilt_limit := deg_to_rad(75)
	
	# Yaw
	camera_pivot.rotation.y -= event.relative.x * mouse_sensitivity

	# Pitch
	pitch -= event.relative.y * mouse_sensitivity
	pitch = clampf(pitch, -tilt_limit, tilt_limit)
	camera_pivot.rotation.x = pitch


static func handle_stick_camera(camera_pivot: Node3D, pitch: float, stick_deadzone: float, stick_look_sensitivity: float, delta: float) -> void:
	var tilt_limit := deg_to_rad(75)
	var look := Vector2(
		Input.get_action_strength("LookRight") - Input.get_action_strength("LookLeft"),
		Input.get_action_strength("LookDown") - Input.get_action_strength("LookUp")
	)

	if look.length() < stick_deadzone:
		return

	# Yaw
	camera_pivot.rotation.y -= look.x * stick_look_sensitivity * delta

	# Pitch
	pitch -= look.y * stick_look_sensitivity * delta
	pitch = clampf(pitch, -tilt_limit, tilt_limit)
	camera_pivot.rotation.x = pitch



#static func calculate_follow_vector(character: CharacterBody3D, partner: CharacterBody3D, min_distance: float, follow_speed: float, delta: float) -> Vector3:
	#var velocity := character.velocity
	#var goto_pos := partner.global_position
	#var distance = (goto_pos - character.global_position).length()
	#
	#if distance > min_distance: ## Should be moving
		#character # global_position.move_toward(goto_pos, follow_speed)
	#
	#if not character.is_on_floor():
		#velocity += get_gravity() * delta

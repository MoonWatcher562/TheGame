extends Script
class_name StateCommon



static func dir(character: Entity) -> Vector3:
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (character.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction


static func move(character: Entity, horiz: bool = false, vert: bool = false) -> void:
	## Vars from character
	var delta: float = character.get_physics_process_delta_time()
	var speed: float = character.speed if "speed" in character else 1.0
	var sprint_mult: float = character.sprint_mult if "sprint_mult" in character else 1.0
	var jump_height: float = character.jump_height if "jump_height" in character else 0.0
	
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (character.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if horiz:
		if direction:
			var sprinting = Input.is_action_pressed("Sprint")
			character.velocity.x = direction.x * speed * sprint_mult if sprinting else 1.0
			character.velocity.z = direction.z * speed * sprint_mult if sprinting else 1.0
		else:
			character.velocity.x = move_toward(character.velocity.x, 0, speed)
			character.velocity.z = move_toward(character.velocity.z, 0, speed)
	
	if vert:
		if not character.is_on_floor():
			character.velocity += character.get_gravity() * delta
		if Input.is_action_just_pressed("ui_accept") and character.is_on_floor():
			character.velocity.y = jump_height





static func hvelocity(character: Entity) -> Vector3:
	## Vars from character
	var velocity: Vector3 = character.velocity
	var speed: float = character.speed if "speed" in character else 1.0
	var sprint_mult: float = character.sprint_mult if "sprint_mult" in character else 1.0
	
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (character.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		var sprinting = Input.is_action_pressed("Sprint")
		velocity.x = direction.x * speed * sprint_mult if sprinting else 1.0
		velocity.z = direction.z * speed * sprint_mult if sprinting else 1.0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	return velocity


static func vvelocity(character: Entity) -> Vector3:
	## Vars from character
	var velocity: Vector3 = character.velocity
	var delta: float = character.get_physics_process_delta_time()
	var jump_height: float = character.jump_height if "jump_height" in character else 0.0
	
	if not character.is_on_floor():
		velocity += character.get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and character.is_on_floor():
		velocity.y = jump_height
	return velocity

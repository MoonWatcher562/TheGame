extends Script
class_name StateCommon



static func dir(character: Entity) -> Vector3:
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (character.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction


static func move(character: Entity) -> void:
	## Vars from character
	var speed: float = character.speed if "speed" in character else 1.0
	var sprint_mult: float = character.sprint_mult if "sprint_mult" in character else 1.0
	
	var direction := dir(character)
	if direction:
		if Input.is_action_pressed("Sprint"): speed *= sprint_mult
		character.velocity.x = direction.x * speed
		character.velocity.z = direction.z * speed
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, speed)
		character.velocity.z = move_toward(character.velocity.z, 0, speed)


static func gravity(character: Entity) -> void:
	if not character.is_on_floor():
		var delta: float = character.get_physics_process_delta_time()
		character.velocity += character.get_gravity() * delta


static func jump(character: Entity) -> void:
	var jump_height: float = character.jump_height if "jump_height" in character else 0.0
	character.velocity.y = jump_height
	character.jumps -= 1

extends CharacterBody3D


# -- Nodes -- #
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var camera_pivot: Node3D = $CameraPivot
@onready var spring_arm: SpringArm3D = $CameraPivot/SpringArm3D
@onready var camera: Camera3D = $CameraPivot/SpringArm3D/Camera3D

# -- Exports -- #
@export var speed: float = 15.0
@export var jump_height: float = 4.5
@export var partner: CharacterBody3D
@export var max_health: float = 100.0
@export var health: float = 100.0

# -- Camera -- #
var mouse_sensitivity := 0.002
var stick_look_sensitivity := 3.0
var stick_deadzone := 0.15
var pitch := 0.0

# -- AI -- #
var min_distance: float = 10.0

# -- States -- #
var state_just_changed: bool = false
var current_state = State.IDLE:      ## Set to initial state
	set(value):
		if value == current_state: return
		current_state = value
		state_just_changed = true
enum State {
	IDLE,
	MOVE,
	FALL,
	JUMP,
	AI_FOLLOW
}

# -- Globals -- #
var active: bool = false
var direction: Vector3
var delta: float

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	update_globals()
	update_state_machine()
	move_and_slide()
	


func update_state_machine() -> void:
	match current_state:
		State.IDLE: idle()
		State.MOVE: move()
		State.JUMP: jump()
		State.FALL: fall()
		State.AI_FOLLOW: ai()


func update_globals() -> void:
	# -- Direction -- #
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	direction = (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# -- Delta -- #
	delta = get_physics_process_delta_time()


func idle() -> void:
	if state_just_changed:
		velocity = Vector3.ZERO
		pass ## Play anim
		state_just_changed = false
	
	# -- Logic -- #
	handle_stick_camera()

	# -- Switches -- #
	if not active:
		current_state = State.AI_FOLLOW
	elif Input.is_action_just_pressed("Jump"):
		current_state = State.JUMP
	elif not is_on_floor():
		current_state = State.FALL
	elif direction != Vector3.ZERO:
		current_state = State.MOVE


func move() -> void:
	if state_just_changed:
		pass ## Play anim
		state_just_changed = false

	# -- Logic -- #
	handle_stick_camera()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# -- Switches -- #
	if not active:
		current_state = State.AI_FOLLOW
	elif Input.is_action_just_pressed("Jump"):
		current_state = State.JUMP
	elif not is_on_floor():
		current_state = State.FALL
	elif velocity == Vector3.ZERO:
		current_state = State.IDLE


func jump() -> void:
	if state_just_changed:
		velocity.y = jump_height
		state_just_changed = false
	
	# -- Logic -- #
	handle_stick_camera()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# -- Switches -- #
	if not active:
		current_state = State.AI_FOLLOW
	elif Input.is_action_just_pressed("Jump"):
		current_state = State.JUMP
	elif velocity.y < 0:
		current_state = State.FALL
	elif velocity == Vector3.ZERO:
		current_state = State.IDLE
	else:
		velocity += get_gravity() * delta


func fall() -> void:
	if state_just_changed:
		pass ## Play anim
		state_just_changed = false
	
	# -- Logic -- #
	handle_stick_camera()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# -- Switches -- #
	if not active:
		current_state = State.AI_FOLLOW
	elif Input.is_action_just_pressed("Jump"):
		current_state = State.JUMP
	elif is_on_floor():
		current_state = State.IDLE
	else:
		velocity += get_gravity() * delta


func ai() -> void:
	if active:
		current_state = State.IDLE
	
	var dir = (partner.global_position - global_position).normalized()
	var distance = abs(global_position - partner.global_position).length()

	if not is_on_floor():
		velocity += get_gravity() * delta

	if distance > min_distance:
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)


func handle_stick_camera() -> void:
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


func damage(dmg: float, bypass_max: bool = false) -> void:
	health -= dmg
	if health <= 0:
		print(name + " is DEAD")
	elif health > max_health and not bypass_max:
		health = max_health
	

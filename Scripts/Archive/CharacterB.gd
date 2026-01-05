extends CharacterBody3D

# Script for Character B in Duo.
# This will control all things specific to the Character like Animation or movement

var active: bool = false
# -- Nodes -- #
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var camera_pivot: Node3D = $CameraPivot
@onready var spring_arm: SpringArm3D = $CameraPivot/SpringArm3D
@onready var camera_slot: Node3D = $CameraPivot/SpringArm3D/CameraSlot
# -- Movement -- #
@export var speed: float = 15.0
@export var jump_height: float = 4.5
# -- Camera -- #
@export var mouse_sensitivity := 0.002
@export var tilt_limit = deg_to_rad(75)
var pitch := 0.0


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	if active:
		handle_movement(_delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity


func handle_movement(delta: float) -> void:
	if not is_on_floor(): velocity += get_gravity() * delta
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_height
	
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

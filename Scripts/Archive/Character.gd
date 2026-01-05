extends CharacterBody3D

# Script for single Character in Duo.
# This will control all things specific to the Character like Animation or movement

var active: bool = false

# -- Nodes -- #
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var camera_pivot: Node3D = $CameraPivot
@onready var spring_arm: SpringArm3D = $CameraPivot/SpringArm3D
@onready var camera_slot: Node3D = $CameraPivot/SpringArm3D/CameraSlot

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
var min_distance := 5.0

# -- Attacking -- #
var combo_length := 1
var current_combo := 0
var is_attacking := false


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	velocity = CharacterHelper.calculate_movement_vector(
		self, 
		camera_pivot, 
		partner, 
		speed,
		jump_height,
		min_distance, 
		delta,
		true, not active)
	
	if active: CharacterHelper.handle_stick_camera(
			camera_pivot,
			pitch,
			stick_deadzone,
			stick_look_sensitivity,
			delta)
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		CharacterHelper.handle_mouse_camera(
			event, 
			camera_pivot,
			mouse_sensitivity,
			pitch
			)


func damage(dmg: float) -> void:
	health -= dmg
	if health <= 0:
		print("DEAD")
	elif health > max_health:
		health = max_health
	print(health)


func handle_attacks() -> void:
	pass

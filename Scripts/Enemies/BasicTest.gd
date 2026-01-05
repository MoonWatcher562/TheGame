extends CharacterBody3D
class_name BasicTestEnemy


# -- Nodes -- #
@onready var mesh_instance: MeshInstance3D = MeshInstance3D.new()
@onready var collision_shape: CollisionShape3D = CollisionShape3D.new()
@onready var targeting_sphere: Area3D = Area3D.new()
@onready var timer: Timer = Timer.new()

# -- Exports -- #
@export var mesh: Mesh
@export var attack_damage: float = 10.0
@export var speed: float = 15.0
@export var jump_height: float = 4.5
@export var max_health: float = 100.0
@export var health: float = 100.0
@export var targeting_radius: float = 10.0
@export var attack_chance: float = 0.02
@export var can_attack: bool = false

# -- States -- #
var state_just_changed: bool = false
var current_state = State.IDLE:
	set(value):
		if value == current_state: return
		current_state = value
		state_just_changed = true
enum State {
	IDLE,
	MOVE,
	FALL
}

# -- Globals -- #
var direction: Vector3
var delta: float
var target: CharacterBody3D
var should_move: bool = true
var timer_done: bool = true


func _ready() -> void:
	assert(mesh, name + " mesh not set")
	
	collision_shape.shape = CapsuleShape3D.new()
	mesh_instance.mesh = mesh
	add_child(mesh_instance)
	add_child(collision_shape)
	
	var shape: CollisionShape3D = CollisionShape3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = 10.0
	shape.shape = sphere
	add_child(targeting_sphere)
	targeting_sphere.add_child(shape)


func _physics_process(_delta: float) -> void:
	update_globals()
	update_state_machine()
	update_all()
	move_and_slide()


func update_globals() -> void:
	# -- Target -- #
	var bodies := targeting_sphere.get_overlapping_bodies()
	if len(bodies) > 0: 
		for body in bodies:
			if body is CharacterBody3D and body != self:
				target = body
				break
			target = null
	else: target = null
	
	# -- Direction -- #
	if target: direction = (target.global_position - global_position).normalized()
	else: direction = Vector3.ZERO
	
	# -- Delta -- #
	delta = get_physics_process_delta_time()


func update_state_machine() -> void:
	match current_state:
		State.IDLE: idle()
		State.MOVE: move()
		State.FALL: fall()


func update_all() -> void:
	## Stuff that should run every update no matter the state
	if target and randf() < attack_chance and can_attack:
		if target.has_method("damage"):
			target.damage(attack_damage)
			print(target.health)


func damage(dmg: float, bypass_max: bool = false) -> void:
	health -= dmg
	if health <= 0:
		print(name + " is DEAD")
	elif health > max_health and not bypass_max:
		health = max_health


func idle() -> void:
	if state_just_changed:
		velocity = Vector3.ZERO
	
	if not is_on_floor():
		current_state = State.FALL
	elif should_move:
		current_state = State.MOVE


func move() -> void:
	if state_just_changed:
		pass
	
	if target:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		look_at(target.global_position)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if not is_on_floor():
		current_state = State.FALL
	elif not should_move:
		current_state = State.IDLE


func fall() -> void:
	if state_just_changed:
		pass
	
	velocity += get_gravity() * delta
	
	if is_on_floor() and should_move:
		current_state = State.MOVE
	elif is_on_floor() and not should_move:
		current_state = State.IDLE


func start_timer(seconds: float, callback: Callable):
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(callback)
	timer.start()

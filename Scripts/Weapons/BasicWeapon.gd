@tool
extends Node3D
class_name BasicWeapon


# -- Children -- #
@onready var mesh_instance := MeshInstance3D.new()
@onready var collision_shape := CollisionShape3D.new()
@onready var area := Area3D.new()

# -- Exports -- #
@export_tool_button("Update") var c: Callable = Callable(self, "update_editor")
@export var mesh: Mesh
@export var collision: Shape3D
@export var damage: float = 20.0
@export var blacklist: Array[CharacterBody3D]

# -- Globals -- #
var active: bool = false


func _ready() -> void:
	# -- Mesh -- #
	mesh_instance.mesh = mesh
	add_child_safe(mesh_instance)
	
	# -- Collisions -- #
	if collision: collision_shape.shape = collision
	else: collision_shape.shape = mesh.create_convex_shape(true, true)
	area.body_entered.connect(hit)
	area.add_child(collision_shape)
	add_child_safe(area)


func update_editor() -> void:
	mesh_instance.mesh = mesh


func hit(body) -> void:
	#var bodies := area.get_overlapping_bodies()
	#print(bodies)
	#if len(bodies) < 1: return
	
	#for body in bodies:
	if body is CharacterBody3D and body.has_method("damage") and not body in blacklist:
		body.damage(damage)
		print(body.name + " was hit")


func add_child_safe(node: Node):
	if not has_node(node.get_path()): 
		add_child(node)

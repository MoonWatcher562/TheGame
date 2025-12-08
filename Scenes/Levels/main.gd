extends Node3D


@onready var terrain: CSGTerrain = $CSGTerrain

func _ready() -> void:
	#region Create CShape for the Terrain
	var cs := CollisionShape3D.new()
	cs.shape = terrain.bake_collision_shape()
	var sb := StaticBody3D.new()
	sb.add_child(cs)
	add_child(sb)
	#endregion
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit(0)

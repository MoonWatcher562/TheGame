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
	
	

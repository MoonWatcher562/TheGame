extends Area3D


@export var damage: float = 1.0

func _physics_process(_delta: float) -> void:
	var overlaps := get_overlapping_bodies()
	if overlaps.size() != 0:
		for body in overlaps:
			if body.has_method("damage"):
				body.damage(damage)

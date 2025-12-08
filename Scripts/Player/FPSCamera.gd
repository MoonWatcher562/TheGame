extends Camera3D

@export var mouse_sensitivity := 0.003
@export var min_pitch := deg_to_rad(-89)
@export var max_pitch := deg_to_rad(89)

var pitch := 0.0  # vertical rotation

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		# rotate parent (horizontal/yaw)
		get_parent().rotate_y(-event.relative.x * mouse_sensitivity)

		# update pitch (vertical look)
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, min_pitch, max_pitch)

		rotation.x = pitch

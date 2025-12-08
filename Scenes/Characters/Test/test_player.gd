extends Entity


@export var speed: float = 10.0
@export var sprint_mult: float = 2.0

@export var jump_height: float = 6.0
var jumps: int = 0
var max_jumps: int = 2


func _physics_process(_delta: float) -> void:
	move_and_slide()

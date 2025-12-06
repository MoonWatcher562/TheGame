extends Entity


var speed: float = 5.0

var jump_height: float = 3.0
var jumps: int = 0
var max_jumps: int = 2


func _physics_process(_delta: float) -> void:
	move_and_slide()

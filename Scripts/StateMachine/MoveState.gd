extends State
class_name MoveState


func enter() -> void: pass
func exit() -> void: pass


func update(_delta: float) -> void:
	if not character.is_on_floor(): state_machine._change_state("FallState")
	elif StateCommon.dir(character) == Vector3.ZERO: state_machine._change_state("IdleState")
	
	StateCommon.move(character, true)
	

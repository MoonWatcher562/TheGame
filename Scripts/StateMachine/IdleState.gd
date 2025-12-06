extends State
class_name IdleState


func enter() -> void:
	character.jumps = 0


func update(_delta: float) -> void:	
	if not character.is_on_floor(): state_machine._change_state("FallState")
	if StateCommon.dir(character) != Vector3.ZERO: state_machine._change_state("MoveState")


func exit() -> void:
	pass

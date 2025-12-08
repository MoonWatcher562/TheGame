extends State
class_name IdleState


func enter() -> void: 
	character.jumps = character.max_jumps

func exit() -> void: pass


func update(_delta: float) -> void:
	if not character.is_on_floor(): state_machine._change_state("FallState")
	elif Input.is_action_just_pressed("Jump") and character.jumps > 0: state_machine._change_state("JumpState")
	elif StateCommon.dir(character) != Vector3.ZERO: state_machine._change_state("MoveState")

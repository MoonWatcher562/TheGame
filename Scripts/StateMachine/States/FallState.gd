extends State
class_name FallState


func enter() -> void: pass
func exit() -> void: pass


func update(_delta: float) -> void:
	if character.is_on_floor(): state_machine._change_state("IdleState")
	elif Input.is_action_just_pressed("Jump") and character.jumps > 0: state_machine._change_state("JumpState")
	
	StateCommon.move(character)
	StateCommon.gravity(character)

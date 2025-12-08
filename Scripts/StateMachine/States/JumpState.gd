extends State
class_name JumpState


func enter() -> void: 
	StateCommon.jump(character)

func exit() -> void: pass


func update(_delta: float) -> void:
	if character.is_on_floor(): state_machine._change_state("IdleState")
	elif character.velocity.y < 0: state_machine._change_state("FallState")
	elif Input.is_action_just_pressed("Jump") and character.jumps > 0: state_machine._change_state("JumpState")
	
	StateCommon.gravity(character)
	StateCommon.move(character)

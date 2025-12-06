extends State
class_name FallState


func enter() -> void:
	pass


func update(_delta: float) -> void:
	if character.is_on_floor(): state_machine._change_state("IdleState")
	
	StateCommon.move(character, true, true)


func exit() -> void:
	pass

extends Node
class_name StateMachine

## Controller for the state machine


@export var character: Entity
@export var initial_state: State

var current_state: State


func _ready() -> void:
	if not character or character is not Entity:
		assert(false, "Invalid State Machine target <loser>")
	
	if not initial_state or initial_state is not State:
		assert(false, "Invalid Initial State <loser x2>")
	current_state = initial_state


func _physics_process(delta: float) -> void:
	current_state.update(delta)
	print(current_state)


func _change_state(new_state: String) -> void:
	if not get_node_or_null(new_state):
		return
	current_state.exit()
	current_state = get_node_or_null(new_state)
	current_state.enter()

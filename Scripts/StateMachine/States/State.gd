@abstract extends Node
class_name State


@onready var state_machine: StateMachine = $".."
@onready var character: CharacterBody3D = state_machine.character

@abstract func enter() -> void
@abstract func update(_delta: float) -> void
@abstract func exit() -> void

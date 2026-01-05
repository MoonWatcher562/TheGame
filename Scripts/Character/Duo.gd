@icon("res://Assets/icons/creatures/fist-red.png")
extends Node3D

# This is the controller for the Duo
# Only reads Input and decides the active character, etc. 

@onready var characterA: CharacterBody3D = $CharacterA
@onready var characterB: CharacterBody3D = $CharacterB

@export var active_character: CharacterBody3D


func _ready() -> void:
	if not active_character: active_character = characterA
	active_character.active = true


func _physics_process(_delta: float) -> void:
	active_character.camera.current = true
	if Input.is_action_just_pressed("SwitchPlayer"): switch()


func switch() -> void:
	active_character.active = false
	match active_character:
		characterA: active_character = characterB
		characterB: active_character = characterA
	active_character.active = true

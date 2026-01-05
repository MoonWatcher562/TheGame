extends Control



@export var duo: Node3D
@onready var label: Label = $Label
@onready var health_bar: ProgressBar = $ProgressBar


func _ready() -> void:
	health_bar.max_value = duo.active_character.max_health

func _process(_delta: float) -> void:
	label.text = "Health: " + str(duo.active_character.health)
	health_bar.value = duo.active_character.health

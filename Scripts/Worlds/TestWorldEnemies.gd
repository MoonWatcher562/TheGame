extends Node3D


func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Quit"): get_tree().quit()

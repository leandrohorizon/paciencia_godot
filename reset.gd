extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.input_event.connect(_on_area2d_input_event)

func _on_area2d_input_event(viewport, event, shape_idx):
	var main = get_node("/root/Main/")
	main.start_game()

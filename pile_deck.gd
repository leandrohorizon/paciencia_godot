extends Node2D

var child = null
const NodeManipulator = preload("res://node_manipulator.gd")

func _ready() -> void:
	$Area2D.input_event.connect(_on_area2d_input_event)

func _on_area2d_input_event(viewport, event, shape_idx):
	if (event is InputEventScreenTouch and event.pressed):
		get_viewport().set_input_as_handled()

		restore_card_stack()

func restore_card_stack():
	var waste = get_node("/root/Main/waste")
	var new_child = waste.last_child()
	var skip = false
	
	while(new_child != waste):
		var undo = get_node("/root/Main/undo")
		undo.register_action(new_child, skip)

		new_child.turn_down()

		self.last_child().append_child(new_child)
		new_child = waste.last_child()
		
		skip = true

func append_child(card):
	NodeManipulator.append_child(self, card, self)

func last_child():
	var target = self

	while target.child != null:
		target = target.child
	
	return target

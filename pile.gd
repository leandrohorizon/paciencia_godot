extends Node2D

var child = null

const NodeManipulator = preload("res://node_manipulator.gd")

func _ready() -> void:
	var viewport = get_viewport()
	viewport.physics_object_picking_sort = true
	viewport.physics_object_picking_first_only = true
	$Area2D.input_event.connect(_on_area2d_input_event)

func _on_area2d_input_event(viewport, event, shape_idx):
	if (event is InputEventScreenTouch and event.pressed):
		get_viewport().set_input_as_handled()

func set_child(card):
	if !validate_new_child(card):
		return
		
	var undo = get_node("/root/Main/undo")
	undo.register_action(card)

	if card.parent != card.parent_pile:
		card.parent.turn_up()

	card.position.x = 0
	append_child(card)

func append_child(card):
	NodeManipulator.append_child(self, card, self)

func validate_new_child(new_child):
	if self.child != null:
		return false
	
	if self.get_meta("pile_type") == "foundation":
		return new_child.value == 1 && new_child.child == null
	
	if self.get_meta("pile_type") == "tableau":
		return new_child.value == 13
	
	return false
	
func last_child():
	var target = self

	while target.child != null:
		target = target.child
	
	return target

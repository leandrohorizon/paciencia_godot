extends Node2D

var child = null

func _ready() -> void:
	$Area2D.input_event.connect(_on_area2d_input_event)

func _on_area2d_input_event(viewport, event, shape_idx):
	if (event is InputEventScreenTouch and event.pressed):
		get_viewport().set_input_as_handled()
		
		var waste = get_node("/root/Main/waste")
		var source = waste.last_child()

		restore_card_stack (source, self)

func restore_card_stack (child, new_parent):
	if child == get_node("/root/Main/waste"):
		return

	var old_child = child
	var old_parent = child.parent

	child.turn_down()
	new_parent.append_child(child)
	child = old_parent

	if child != null:
		restore_card_stack (child, old_child)

func set_child(card):
	card.turn_down()
	append_child(card)

func append_child(card):
	card.set_parent(self)
	card.set_parent_pile(self)

	self.add_child(card)
	self.child = card

func last_child():
	var target = self

	while target.child != null:
		target = target.child
	
	return target

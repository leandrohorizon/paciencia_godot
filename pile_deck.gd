extends Node2D

var child = null

func _ready() -> void:
	var viewport = get_viewport()
	viewport.physics_object_picking_sort = true
	viewport.physics_object_picking_first_only = true
	$Area2D.input_event.connect(_on_area2d_input_event)

func _on_area2d_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or \
	   (event is InputEventScreenTouch and event.pressed):
		get_viewport().set_input_as_handled()
		
		var waste = get_node("/root/Main/waste")
		var source = waste.last_child()

		pegar_de_volta_carta_pai(source, self)

func pegar_de_volta_carta_pai(child, new_parent):
	if child == get_node("/root/Main/waste"):
		return

	var old_child = child
	var old_parent = child.parent

	child.turn_down()
	new_parent.append_child(child)
	child = old_parent

	if child != null:
		pegar_de_volta_carta_pai(child, old_child)

func set_child(card):
	card.turn_down()
	append_child(card)

func append_child(card):
	card.parent.remove_child(card)
	card.parent.child = null

	self.add_child(card)
	self.child = card

	card.set_parent(self)
	card.set_parent_pile(self)

func last_child():
	var target = self

	while true:
		if target.child == null:
			return target
		
		target = target.child
	return target

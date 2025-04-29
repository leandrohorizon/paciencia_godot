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

		var main = get_node("/root/Main")

		if main.card_selected == null:
			return
		
		var card = main.card_selected
		self.set_child(card)
		main.card_selected = null

func set_child(card):
	if !validate_new_child(card):
		return

	if card.parent != card.parent_pile:
		card.parent.turn_up()

	card.position.x = 0
	append_child(card)
	
func append_child(card):
	card.parent.remove_child(card)
	self.add_child(card)
	
	print("parent: ", self)
	print("parent_pile: ", self)

	self.child = card
	card.parent.child = null
	card.set_parent(self)
	card.set_parent_pile(self)
	

func validate_new_child(new_child):
	if self.get_meta("pile_type") == "foundation":
		return new_child.value == 1
	
	if self.get_meta("pile_type") == "tableau":
		return new_child.value == 13
	
	return false
	
func last_child():
	var target = self

	while true:
		if target.child == null:
			return target
		
		target = target.child

extends Node2D

var child = null

func _ready() -> void:
	var viewport = get_viewport()
	viewport.physics_object_picking_sort = true
	viewport.physics_object_picking_first_only = true
	$Area2D.input_event.connect(_on_area2d_input_event)

func _on_area2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_viewport().set_input_as_handled()
		
		if self.get_meta("pile_type") == "deck":
			var waste = get_node("/root/Main/waste")
			var target = waste.last_child()

			while target != waste:				
				print(target.parent)
#
				target.turn_down()
				target.parent.remove_child(target)
				self.add_child(target)
				
				self.last_child().child = target
				var old_parent = target.parent

				target.set_parent(self)
				target.set_parent_pile(self)
#
				target = old_parent

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

	card.position.y = 0
	card.parent.remove_child(card)
	self.add_child(card)

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

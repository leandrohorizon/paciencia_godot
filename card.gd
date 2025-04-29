extends Node2D

var value = null
var suit = null
var is_face_up = null
var parent = null
var child = null
var parent_pile = null

func setup(value, suit):
	self.value = value
	self.suit = suit

func _ready() -> void:
	var viewport = get_viewport()
	viewport.physics_object_picking_sort = true
	viewport.physics_object_picking_first_only = true
	$Area2D.input_event.connect(_on_area2d_input_event)

func _on_area2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_viewport().set_input_as_handled()

		if !self.is_face_up:
			return

		print("Objeto clicado: ", self.to_str())
		
		var main = get_node("/root/Main")

		if main.card_selected == null:
			main.card_selected = self
		else:
			var card = main.card_selected
			self.set_child(card)
			main.card_selected = null

func set_child(card):
	print(self.to_str(), " > ", card.to_str(), " = ", validate_new_child(card))
	
	if !validate_new_child(card):
		return

	if card.parent != card.parent_pile:
		card.parent.turn_up()

	if self.parent_pile.get_meta("pile_type") == "foundation":
		card.position.y = 0

	if self.parent_pile.get_meta("pile_type") == "tableau":
		card.position.y = 40

	card.parent.remove_child(card)
	self.add_child(card)
	
	self.child = card
	card.set_parent(self)
	card.set_parent_pile(self.parent_pile)

func validate_new_child(new_child):
	if parent_pile.get_meta("pile_type") == "foundation":
		var valid_value = self.value + 1

		return new_child.value == valid_value && self.suit == new_child.suit

	if parent_pile.get_meta("pile_type") == "tableau":
		var valid_value = value - 1

		return new_child.value == valid_value && self.suit_color() != new_child.suit_color()

func suit_color():
	match self.suit:
		"clubs", "spades":
			return "black"
		"diamonds", "hearts":
			return "red"

func set_parent(parent):
	self.parent = parent
	
func set_parent_pile(pile):
	self.parent_pile = pile

func turn_up():
	self.is_face_up = true
	var sprite = $Area2D/Sprite2D
	var image_path = "res://assets/card-%s-%d.png" % [suit, value]
	sprite.texture = load(image_path)

func turn_down():
	self.is_face_up = false
	var sprite = $Area2D/Sprite2D
	var image_path = "res://assets/card-back1.png"
	sprite.texture = load(image_path)

func to_str():
	return "%s-%d" % [suit, value]

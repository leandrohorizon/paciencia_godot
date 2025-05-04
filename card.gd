extends Node2D

var value = null
var suit = null
var is_face_up = null
var parent = null
var child = null
var parent_pile = null

const NodeManipulator = preload("res://node_manipulator.gd")

func setup(value, suit):
	self.value = value
	self.suit = suit

func _ready() -> void:
	$Area2D.input_event.connect(_on_area2d_input_event)

func _on_area2d_input_event(viewport, event, shape_idx):
	if (event is InputEventScreenTouch and event.pressed):
		get_viewport().set_input_as_handled()
		
		if self.is_face_up:
			auto_stack_self()
			return;

		if self.parent_pile.get_meta("pile_type") == "deck":
			self.turn_up()
			var waste = get_node("/root/Main/waste")
			var target = waste.last_child()

			self.position.x = 0
			
			target.append_child(self)

func auto_stack_self():
	var piles = foundations()
	piles.append_array(tableaus())

	for pile in piles:
		var pile_path = "/root/Main/" + pile
		var pile_node = get_node(pile_path)
		
		var new_parent = pile_node.last_child()
		
		if new_parent.validate_new_child(self):
			new_parent.set_child(self)
			return
	
func foundations() -> Array:
	return [
		"foundation1", "foundation2", "foundation3", "foundation4"
	]

func tableaus() -> Array:
	return [
		"tableau1", "tableau2", "tableau3",
		"tableau4", "tableau5", "tableau6",
		"tableau7"
	]

func set_child(card):
	print(self.to_str(), " > ", card.to_str(), " = ", validate_new_child(card))
		
	if  !validate_new_child(card):
		return

	if card.parent != card.parent_pile:
		card.parent.turn_up()

	if self.parent_pile.get_meta("pile_type") == "foundation":
		card.position.x = 0

	if self.parent_pile.get_meta("pile_type") == "tableau":
		card.position.x = 35

	append_child(card)

func validate_new_child(new_child):
	if self.child != null:
		return false

	if parent_pile.get_meta("pile_type") == "foundation" && new_child.child == null:
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

func append_child(card):
	NodeManipulator.append_child(self, card)

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

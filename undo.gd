extends Node2D

var action_stack = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.input_event.connect(_on_area2d_input_event)

func _on_area2d_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.pressed:
		undo_action()

func register_action(card, skip = false):
	var is_face_up = null
	var parent = card.parent

	if parent.get_script().resource_path == "res://card.gd":
		is_face_up = parent.is_face_up

	action_stack.append(
		{
			"card": { "node": card, "position": card.position, "is_face_up": card.is_face_up },
			"parent": { "node": parent, "is_face_up": is_face_up },
			"skip": skip
		}
	)

func undo_action():
	if action_stack.size() > 0:
		var last_action = action_stack.pop_back()
		var card = last_action["card"]
		var parent = last_action["parent"]
		var skip = last_action["skip"]
		
		self.to_str(last_action)
		
		var card_node = card["node"]
		card_node.position = card["position"]
		if card["is_face_up"]:
			card_node.turn_up()
		else:
			card_node.turn_down()

		var parent_node = parent["node"]
		if parent_node.get_script().resource_path == "res://card.gd":
			if parent["is_face_up"]:
				parent_node.turn_up()
			else:
				parent_node.turn_down()

		parent_node.append_child(card_node)

		if skip: undo_action()

func clear_action_stack():
	self.action_stack = []

func to_str(action):
	var card = action["card"]["node"]
	var parent = action["parent"]["node"]
	var skip = action["skip"]
	
	if parent.get_script().resource_path == "res://card.gd":
		print(parent.to_str(), " > ", card.to_str(), " ", skip)
	else:
		print(parent, " > ", card.to_str(), " ", skip)
	

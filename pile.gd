extends Node2D

var child = null

func set_child(card):
	if !validate_new_child(card):
		return

	self.child = card
	card.set_parent(self)

func validate_new_child(new_child):
	if self.get_meta("pile_type") == "foundation":
		return new_child.value == 1
	
	if self.get_meta("pile_type") == "tableau":
		return new_child.value == 13
	
	return false

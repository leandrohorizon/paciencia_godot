class_name NodeManipulator

static func append_child(node, new_child, new_parent_pile = null):
	set_parent(new_child, node)

	if new_parent_pile == null:
		new_parent_pile = node.parent_pile

	new_child.set_parent_pile(new_parent_pile)
	node.add_child(new_child)
	node.child = new_child

static func set_parent(node, parent):
	remove_parent(node)
	node.parent = parent
	
static func remove_parent(node):
	if node.parent == null:
		return

	node.parent.remove_child(node)

	if node.parent.child == node:
		node.parent.child = null

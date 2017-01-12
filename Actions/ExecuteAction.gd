extends '../Behavior.gd'

var node
var action

func _init(node, action):
	self.node = node
	self.action = action

func update(context, delta):
	return node.call(action, context)

extends '../Behavior.gd'

var child_tree

func _init(child_tree):
	self.child_tree = child_tree

func update(context, delta):
	child_tree.tick()
	
	return TaskStatus.SUCCESS

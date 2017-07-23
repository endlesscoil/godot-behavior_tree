extends 'Decorator.gd'

var node
var conditional			# Conditional
var should_reevaluate	# bool
var conditional_status 	# TaskStatus

func _init(node, conditional, should_reevaluate=false):
	self.node = node
	self.conditional = conditional
	self.should_reevaluate = should_reevaluate

func on_start():
	conditional_status = TaskStatus.INVALID

func update(context, delta):
	conditional_status = execute_conditional(context)

	if (conditional_status == TaskStatus.SUCCESS):
		return child.tick(context, delta)

	return TaskStatus.FAILURE

func invalidate():
	conditional_status = TaskStatus.INVALID

func execute_conditional(context, force_update = false):
	if force_update or should_reevaluate or conditional_status == TaskStatus.INVALID:
		conditional_status = node.call(conditional, context)

	return conditional_status
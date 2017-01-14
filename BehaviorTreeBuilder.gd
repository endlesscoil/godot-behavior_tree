var AbortTypes = preload('res://ai/BehaviorTree/Composites/AbortTypes.gd').new()
var BehaviorTree = preload('res://ai/BehaviorTree/BehaviorTree.gd')
var Composite = preload('res://ai/BehaviorTree/Composites/Composite.gd')
var Selector = preload('res://ai/BehaviorTree/Composites/Selector.gd')
var Sequence = preload('res://ai/BehaviorTree/Composites/Sequence.gd')
var Decorator = preload('res://ai/BehaviorTree/Decorators/Decorator.gd')
var ConditionalDecorator = preload('res://ai/BehaviorTree/Decorators/ConditionalDecorator.gd')
var LogAction = preload('res://ai/BehaviorTree/Actions/LogAction.gd')
var ExecuteAction = preload('res://ai/BehaviorTree/Actions/ExecuteAction.gd')
var WaitAction = preload('res://ai/BehaviorTree/Actions/WaitAction.gd')

var context

var current_node = null			# Behavior
var parent_node_stack = []		# Stack<Behavior>

func _init(context):
	self.context = context
	self.current_node = null
	self.parent_node_stack = []

func set_child_on_parent(child):
	var parent = parent_node_stack[-1]
	if parent extends Composite:
		parent.add_child(child)
	elif parent extends Decorator:
		parent.child = child
		end_decorator()
		
	return self

func push_parent_node(composite):
	if parent_node_stack.size() > 0:
		set_child_on_parent(composite)
	
	parent_node_stack.push_back(composite)
	return self
	
func end_decorator():
	current_node = parent_node_stack[-1]
	parent_node_stack.pop_back()
	return self
	
func action(node, function):
	return set_child_on_parent(ExecuteAction.new(node, function))
	
func conditional(node, function):
	# TODO: implement this when ExecuteActionConditional is done
	pass
	
func conditional_bool(node, function):
	# TODO: implement this when ExecuteActionConditional is done
	pass
	
func log_action(text):
	return set_child_on_parent(LogAction.new(text))
	
func wait_action(wait_time):
	return set_child_on_parent(WaitAction.new(wait_time))
	
func sub_tree(sub_behavior_tree):
	# TODO: implement this when BehaviorTreeReference is done
	pass
	
func conditional_decorator(node, function, should_reevaluate=true):
	return push_parent_node(ConditionalDecorator.new(node, function, should_reevaluate))

func always_fail():
	pass # TODO
	
func always_succeed():
	pass # TODO
	
func inverter():
	pass # TODO
	
func repeater(count):
	pass # TODO
	
func until_fail():
	pass # TODO
	
func until_success():
	pass # TODO
	
func parallel():
	pass # TODO
	
func parallel_elector():
	pass # TODO
	
func selector(abort_type=AbortTypes.NONE):
	return push_parent_node(Selector.new(abort_type))
	
func random_selector():
	pass # TODO
	
func sequence(abort_type = AbortTypes.NONE):
	return push_parent_node(Sequence.new(abort_type))
	
func random_sequence():
	pass # TODO
	
func end_composite():
	current_node = parent_node_stack[-1]
	parent_node_stack.pop_back()
	return self

func build():
	return BehaviorTree.new(context, current_node)
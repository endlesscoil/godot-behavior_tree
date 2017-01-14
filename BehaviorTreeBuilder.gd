var BehaviorTree = preload('BehaviorTree.gd')

var AbortTypes = preload('Composites/AbortTypes.gd').new()
var Composite = preload('Composites/Composite.gd')
var Selector = preload('Composites/Selector.gd')
var Sequence = preload('Composites/Sequence.gd')
var Parallel = preload('Composites/Parallel.gd')
var ParallelSelector = preload('Composites/ParallelSelector.gd')
var RandomSelector = preload('Composites/RandomSelector.gd')
var RandomSequence = preload('Composites/RandomSequence.gd')

var ExecuteActionConditional = preload('Conditionals/ExecuteActionConditional.gd')

var Decorator = preload('Decorators/Decorator.gd')
var ConditionalDecorator = preload('Decorators/ConditionalDecorator.gd')
var AlwaysFail = preload('Decorators/AlwaysFail.gd')
var AlwaysSucceed = preload('Decorators/AlwaysSucceed.gd')
var Inverter = preload('Decorators/Inverter.gd')
var Repeater = preload('Decorators/Repeater.gd')

var LogAction = preload('Actions/LogAction.gd')
var ExecuteAction = preload('Actions/ExecuteAction.gd')
var WaitAction = preload('Actions/WaitAction.gd')
var BehaviorTreeReference = preload('Actions/BehaviorTreeReference.gd')

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
	return set_child_on_parent(ExecuteActionConditional.new(node, function))

# TODO: Do we really need to implement this?  Slightly more difficult without anonymous functions and probably not worth it.	
func conditional_bool(node, function):
	pass
	
func log_action(text):
	return set_child_on_parent(LogAction.new(text))
	
func wait_action(wait_time):
	return set_child_on_parent(WaitAction.new(wait_time))
	
func sub_tree(sub_behavior_tree):
	return set_child_on_parent(BehaviorTreeReference.new(sub_behavior_tree))
	
func conditional_decorator(node, function, should_reevaluate=true):
	return push_parent_node(ConditionalDecorator.new(node, function, should_reevaluate))

func always_fail():
	return push_parent_node(AlwaysFail.new())
	
func always_succeed():
	return push_parent_node(AlwaysSucceed.new())
	
func inverter():
	return push_parent_node(Inverter.new())
	
func repeater(count):
	return push_parent_node(Repeater.new(count))
	
func until_fail():
	pass # TODO
	
func until_success():
	pass # TODO
	
func parallel():
	return push_parent_node(Parallel.new())

func parallel_selector():
	return push_parent_node(ParallelSelector.new())
	
func selector(abort_type=AbortTypes.NONE):
	return push_parent_node(Selector.new(abort_type))
	
func random_selector():
	return push_parent_node(RandomSelector.new())
	
func sequence(abort_type = AbortTypes.NONE):
	return push_parent_node(Sequence.new(abort_type))
	
func random_sequence():
	return push_parent_node(RandomSequence.new())
	
func end_composite():
	current_node = parent_node_stack[-1]
	parent_node_stack.pop_back()
	return self

func build():
	return BehaviorTree.new(context, current_node)

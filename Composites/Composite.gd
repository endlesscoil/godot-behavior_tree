extends '../Behavior.gd'

#var TaskStatus = preload('res://ai/BehaviorTree/TaskStatus.gd').new()
var AbortTypes = preload('res://ai/BehaviorTree/Composites/AbortTypes.gd').new()
var Conditional = preload('res://ai/BehaviorTree/Conditionals/Conditional.gd')
var ConditionalDecorator = preload('res://ai/BehaviorTree/Decorators/ConditionalDecorator.gd')

var abort_type = AbortTypes.NONE
var children = []
var has_lower_priority_conditional_abort = false;
var current_child_index = 0;

func on_start():
	has_lower_priority_conditional_abort = has_lower_priority_conditional_abort_in_children()
	current_child_index = 0
	
func on_end():
	for c in children:
		c.invalidate()
	
func invalidate():
	pass
	
func add_child(child):
	children.append(child)
	
func is_first_child_conditional():
	return children[0] extends Conditional or children[0] extends ConditionalDecorator

func has_lower_priority_conditional_abort_in_children():
	for c in children:
		if c.abort_type & AbortTypes.LOWER_PRIORITY:
			return true
			
	return false
	
func update_lower_priority_abort_conditional(context, delta, status_check):
	for i in range(0, current_child_index):
		var c = children[i]
		if c.abort_type & AbortTypes.LOWER_PRIORITY:
			var child = c.children[0]
			var status = update_conditional_node(context, delta, child)
			if status != status_check:
				current_child_index = i
				
				for j in range(i, children.size()):
					children[j].invalidate()
				
				break
				
func update_self_abort_conditional(context, delta, status_check):
	for i in range(0, current_child_index):
		var c = children[i]
		
		if not c extends Conditional:
			continue
		
		var status = update_conditional_node(context, delta, c)
		if status != status_check:
			current_child_index = i
			
			for j in range(i, children.size()):
				children[j].invalidate()
				
			break
			
func update_conditional_node(context, delta, node):
	if node extends ConditionalDecorator:
		return node.execute_conditional(context, delta, true)
	else:
		return node.update(context, delta)

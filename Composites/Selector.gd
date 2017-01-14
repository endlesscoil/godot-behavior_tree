extends 'Composite.gd'

func _init(abort_type = null):
	if abort_type == null:
		abort_type = AbortTypes.NONE
		
func update(context, delta):
	if current_child_index != 0:
		handle_conditional_aborts(context)
		
	var current = children[current_child_index]
	var status = current.tick(context, delta)
	print('Selector::update idx=', current_child_index, ' status=', status)
	
	if status == TaskStatus.SUCCESS:
		current_child_index = 0
	
	if status != TaskStatus.FAILURE:
		return status
		
	current_child_index += 1
	
	if current_child_index == children.size():
		current_child_index = 0
		return TaskStatus.FAILURE
		
	return TaskStatus.RUNNING

func handle_conditional_aborts(context):
	if has_lower_priority_conditional_abort:
		update_lower_priority_abort_conditional(context, TaskStatus.SUCCESS)
		
	if abort_type & AbortTypes.SELF:
		update_self_abort_conditional(context, TaskStatus.SUCCESS)

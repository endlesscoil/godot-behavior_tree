extends 'Composite.gd'

# The selector task is similar to an "or" operation. It will return success as soon as one of its child tasks return success. If a
# child task returns failure then it will sequentially run the next task. If no child task returns success then it will return failure.

func _init(abort_type = null):
	if abort_type == null:
		abort_type = AbortTypes.NONE
		
func update(context, delta):
	if current_child_index != 0:
		handle_conditional_aborts(context)
		
	var current = children[current_child_index]
	var status = current.tick(context, delta)
	
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

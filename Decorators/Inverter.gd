extends 'Decorator.gd'

func update(context, delta):
	var status = child.update(context, delta)
	
	if status == TaskStatus.SUCCESS:
		return TaskStatus.FAILURE
	
	if status == TaskStatus.FAILURE:
		return TaskStatus.SUCCESS
		
	return TaskStatus.RUNNING

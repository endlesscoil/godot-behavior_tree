extends 'Decorator.gd'

func update(context, delta):
	var status = child.update(context, delta)
	
	if status != TaskStatus.FAILURE:
		return TaskStatus.RUNNING
		
	return TaskStatus.SUCCESS

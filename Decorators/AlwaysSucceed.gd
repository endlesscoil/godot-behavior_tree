extends 'Decorator.gd'

func update(context, delta):
	var status = child.update(context, delta)
	
	if status == TaskStatus.RUNNING:
		return status
		
	return TaskStatus.SUCCESS

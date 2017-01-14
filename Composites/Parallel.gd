extends 'Composite.gd'
		
func update(context, delta):
	var did_all_succeed = true
	
	for i in range(children.size()):
		var child = children[i]
		child.tick(context, delta)
		
		if child.status == TaskStatus.FAILURE:
			return TaskStatus.FAILURE
		elif child.status != TaskStatus.SUCCESS:
			did_all_succeed = false
			
	if did_all_succeed == true:
		return TaskStatus.SUCCESS
		
	return TaskStatus.RUNNING

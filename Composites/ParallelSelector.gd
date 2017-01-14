extends 'Composite.gd'

# Similar to the selector task, the ParallelSelector task will return success as soon as a child task returns success. The difference
# is that the parallel task will run all of its children tasks simultaneously versus running each task one at a time. If one tasks returns
# success the parallel selector task will end all of the child tasks and return success. If every child task returns failure then the
# ParallelSelector task will return failure.
						
func update(context, delta):
	var did_all_fail = true
	
	for i in range(children.size()):
		var child = children[i]
		child.tick(context, delta)
		
		if child.status == TaskStatus.SUCCESS:
			return TaskStatus.SUCCESS
		elif child.status != TaskStatus.FAILURE:
			did_all_fail = false
			
	if did_all_fail == true:
		return TaskStatus.FAILURE
		
	return TaskStatus.RUNNING

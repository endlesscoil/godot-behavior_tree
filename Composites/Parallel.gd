extends 'Composite.gd'

# The parallel task will run each child task until a child task returns failure. The difference is that the parallel task will run all of
# its children tasks simultaneously versus running each task one at a time. Like the sequence class, the parallel task will return
# success once all of its children tasks have returned success. If one tasks returns failure the parallel task will end all of the child
# tasks and return failure.

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

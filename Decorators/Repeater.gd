extends 'Decorator.gd'

var count
var repeat_forever
var end_on_failure
var iteration_count = 0

func _init(count=0, repeat_forever=false, end_on_failure=false):
	self.count = count
	self.repeat_forever = repeat_forever
	self.end_on_failure = end_on_failure

func on_start():
	iteration_count = 0

func update(context, delta):
	if not repeat_forever and iteration_count == count:
		return TaskStatus.SUCCESS
		
	var status = child.tick(context, delta)
	iteration_count += 1
	
	if end_on_failure and status == TaskStatus.FAILURE:
		return TaskStatus.SUCCESS
		
	if not repeat_forever and iteration_count == count:
		return TaskStatus.SUCCESS
	
	return TaskStatus.RUNNING

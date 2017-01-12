
var status # TaskStatus

var TaskStatus = preload('res://ai/BehaviorTree/TaskStatus.gd').new()

func _init():
	pass
	
func invalidate():
	status = TaskStatus.INVALID
	
func on_start():
	pass
	
func on_end():
	pass

func update(context, delta):
	pass

func tick(context, delta):
	if status == TaskStatus.INVALID:
		on_start()
		
	status = update(context, delta)
	
	if status != TaskStatus.RUNNING:
		on_end()
		
	return status
extends '../Behavior.gd'

var wait_time = 0
var start_time = 0

func _init(wait_time):
	self.wait_time = wait_time

func on_start():
	start_time = 0

func update(context, delta):
	if start_time == 0:
		start_time = OS.get_unix_time()

	if OS.get_unix_time() - start_time >= wait_time:
		return TaskStatus.SUCCESS
	
	return TaskStatus.RUNNING

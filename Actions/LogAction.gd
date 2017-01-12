extends '../Behavior.gd'

var text = ''

func _init(text):
	self.text = text

func update(context, delta):
	print(text)
	
	return TaskStatus.SUCCESS

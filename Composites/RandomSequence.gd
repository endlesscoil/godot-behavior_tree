extends 'Sequence.gd'

func on_start():
	for i in range(children.size(), 1, -1):
		var j = randi() % i
		
		var temp = children[j]
		children[j] = children[i]
		children[i] = temp

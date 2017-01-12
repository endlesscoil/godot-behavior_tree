export(float) var update_period;

var context;	# Dictionary
var root;		# Behavior
var elapsed_time

func _init(context, root_node, update_period = 0.2):
	self.context = context
	self.root = root_node
	
	self.update_period = update_period
	self.elapsed_time = update_period

func tick(delta):
	if update_period > 0:
		elapsed_time -= delta
		
		if elapsed_time <= 0:
			while elapsed_time <= 0:
				elapsed_time += update_period
				
			print('BehaviorTree::tick')
			root.tick(context, delta)
	else:
		print ('BehaviorTree::tick (2)')
		root.tick(context, delta)

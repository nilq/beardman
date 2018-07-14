extends StaticBody2D

var door_friend

var can_trigger = true

func _ready():
	var children = get_node("..").get_children()
	
	randomize()
	
	door_friend  = children[rand_range(0, children.size())]
	
	while door_friend == self:
		randomize()

		door_friend  = children[rand_range(0, children.size())]
		
func get_door():
	if self.can_trigger:
		door_friend.can_trigger = false

		return door_friend
	else:
		return self
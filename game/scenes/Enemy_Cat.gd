extends KinematicBody2D

onready var player = get_node("../Player")

func _process(delta):
	var player_position = player.get_position()
	look_at(player_position)
	
	var direction = player_position - self.get_position()
	#print(direction)
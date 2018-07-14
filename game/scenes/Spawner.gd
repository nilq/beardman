extends Node2D

onready var world = get_node("..")
onready var enemy_cat = preload( "res://enemies/Cat.tscn" ).instance()
var catCounter = 0

func _process(delta):
	
	if catCounter < 50:
		var cat = enemy_cat.duplicate()
		cat.set_position(self.get_position())		
		
		world.add_child(cat)

		catCounter += 1
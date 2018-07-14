extends Node2D

onready var world = get_node("..")
onready var enemy_cat = preload( "res://scenes/Cat.tscn" ).instance()

onready var player = world.get_node("Player")

var cat_counter = 0
var cat_range   = 60

func _ready():
	self.start_timer()

func start_timer():
	var timer = Timer.new()

	timer.set_wait_time(4)
	timer.connect("timeout", self, "spawn_cat", [timer])

	self.add_child(timer)

	timer.start()

func spawn_cat(timer):
	if self.get_global_position().distance_to(player.get_global_position()) < 1600:
		for i in range(1, 4):
			var cat = enemy_cat.duplicate()
			cat.set_position(self.get_position() + Vector2(rand_range(-cat_range, cat_range), rand_range(-cat_range, cat_range)))
			
			world.add_child(cat)
		
			cat_counter += 1
			
		timer.stop()

		self.start_timer()
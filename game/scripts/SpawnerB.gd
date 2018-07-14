extends Node2D

onready var world = get_node("..")
onready var enemy_barber = preload( "res://scenes/Barber.tscn" ).instance()

onready var player = world.get_node("Player")

var barber_counter = 0
var barber_range   = 60

func _ready():
	self.start_timer()

func start_timer():
	var timer = Timer.new()

	timer.set_wait_time(10)
	timer.connect("timeout", self, "spawn_barber", [timer])

	self.add_child(timer)

	timer.start()

func spawn_barber(timer):
	if self.get_global_position().distance_to(player.get_global_position()) < 2600:
		print("insert barber here")
		for i in range(1, 2):
			var barber = enemy_barber.duplicate()
			barber.set_position(self.get_position() + Vector2(rand_range(-barber_range, barber_range), rand_range(-barber_range, barber_range)))
			
			world.add_child(barber)
		
			barber_counter += 1
			
		timer.stop()

		self.start_timer()
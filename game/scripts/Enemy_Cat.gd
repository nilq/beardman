extends KinematicBody2D

onready var player = get_node("../Player")

var target_range = 100

onready var direction 	 	 = self.get_target_direction()
onready var smooth_direction = direction

var speed 		 = 7
var attack_range = 100

func _ready():
	var timer = Timer.new()
	
	timer.set_wait_time(0.25)
	timer.connect("timeout", self, "change_direction")
	
	add_child(timer)
	
	timer.start()

func change_direction():
	direction = self.get_target_direction()

func get_target_direction():
	return player.get_position() + Vector2(rand_range(-target_range, target_range), rand_range(-target_range, target_range))

func _process(delta):
	smooth_direction.x = lerp(smooth_direction.x, direction.x, delta * 2)
	smooth_direction.y = lerp(smooth_direction.y, direction.y, delta * 2)
	
	look_at(smooth_direction)
	
	if self.get_position().distance_to(smooth_direction) > attack_range:
		var a = smooth_direction.angle_to_point(self.get_position())
		self.move_and_collide(Vector2(cos(a), sin(a)) * speed)

extends KinematicBody2D

onready var player = get_node("../Player")

var target_range = 100
var damage = 5
onready var direction 	 	 = self.get_target_direction()
onready var smooth_direction = direction

var speed 		 = 7
var attack_range = 100
var angle  		 = 0

var attack_interval = 0.5
var attack_timer

var random_angle_multiplier = rand_range(-target_range, target_range)

func _ready():
	self.set_meta("type", "enemy")
	self.set_meta("variant", "cat")
	$Animation.play("movement")
	
	var timer = Timer.new()
	timer.set_wait_time(0.25)
	timer.connect("timeout", self, "change_direction")
	
	add_child(timer)
	
	timer.start()
	
	attack_timer = Timer.new()
	attack_timer.set_wait_time(attack_interval)
	attack_timer.autostart = false
	attack_timer.one_shot = true
	attack_timer.process_mode = Timer.TIMER_PROCESS_IDLE
	add_child(attack_timer)
	

func change_direction():
	direction = self.get_target_direction()
	angle     = smooth_direction.angle_to_point(self.get_position())

	random_angle_multiplier = rand_range(-1, 1) * target_range * 5

func get_target_direction():
	return player.get_position() + Vector2(rand_range(-target_range, target_range), rand_range(-target_range, target_range))

func _process(delta):
	smooth_direction.x = lerp(smooth_direction.x, direction.x, delta * 2)
	smooth_direction.y = lerp(smooth_direction.y, direction.y, delta * 2)
	
	look_at(smooth_direction)
	
	

	if self.get_position().distance_to(smooth_direction) > attack_range:
		var a = smooth_direction.angle_to_point(self.get_position())
		
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(self.get_global_position(), smooth_direction)
		
		if result:
			if not "Player" in result.collider.name and not "Enemy_Cat" in result.collider.name:
				angle = lerp(angle, angle + random_angle_multiplier, delta * 5)

		var collision = self.move_and_collide(Vector2(cos(angle), sin(angle)) * speed)
		try_attack(collision)
		
func try_attack(collision):
	if attack_timer.is_stopped() \
	&& collision != null \
	&& collision.collider.has_meta("type") \
	&& collision.collider.get_meta("type") != "enemy":
		self.set_z_index(1000)
		$Animation.play("attack")
		$Animation.connect("animation_finished", self, "resume_movement")
		collision.collider.apply_damage(damage)
		attack_timer.start()
		
func resume_movement():
	self.set_z_index(0)
	$Animation.play("movement")
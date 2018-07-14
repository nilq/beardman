extends Sprite

onready var BEARD_POS   = self.get_position()
onready var BEARD_SCALE = Vector2(self.get_scale().x, self.get_scale().y / 1.25)


onready var blood = preload( "res://scenes/blood.tscn" ).instance()


var is_bearding = false
var beard_time  = 0.075


func _ready():
	set_modulate(Color(1, 1, 1, 0))


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT and !is_bearding:
			self.fire()


func fire():
	var fade = $FadeTween
	
	fade.interpolate_property(self, "modulate", 
	    Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.1, 
	    Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		
	fade.start()
	
	var sound = $WhipSound
	
	sound.set_pitch_scale(rand_range(0.95, 1.25))
	
	sound.play()
	
	var beard_scale = BEARD_SCALE
	var beard_pos   = self.get_position()
	
	var mouse_pos = self.get_node("../Cam").get_global_mouse_position()
	
	# Calculate beard collisions
	var space_state = get_world_2d().direct_space_state
	var result 		= space_state.intersect_ray(self.get_global_position(), mouse_pos)

	var point  	   = mouse_pos
	
	if result:
		var smash = $PunchSound
	
		smash.set_pitch_scale(rand_range(0.9, 1))		
		smash.play()

		point = result.position
		
		if "Enemy_Cat" in result.collider.name:
			var meow   = $Meow.duplicate()
			var splash = $Splash.duplicate()

			add_child(meow)
			add_child(splash)

			meow.play()
			splash.play()
			
			var new_blood = blood.duplicate()
			
			new_blood.set_rotation(rand_range(-360, 360))
			new_blood.set_position(result.position)
			var blood_file = "blood_" + str(ceil(rand_range(0.1, 2.9)))
			new_blood.set_texture(load("res://sprites/cat/" + blood_file + ".png"))
			self.get_node("../..").add_child(new_blood)
			result.collider.queue_free()

	var distance   = point.distance_to(self.get_global_position())
	var dist_scale = distance / (self.get_texture().get_size().y + 10)


	var tween = $GunTween
	tween.interpolate_property(self, "scale",
	                BEARD_SCALE, Vector2(BEARD_SCALE.x, dist_scale), beard_time,
	                Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
					
	tween.interpolate_callback(self, beard_time, "retract_beard", distance)

	tween.start()
	
	is_bearding = true


func retract_beard(distance):
	var tween = $GunTween

	tween.interpolate_property(self, "scale",
	                self.get_scale(), BEARD_SCALE, beard_time,
	                Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)

	tween.interpolate_callback(self, beard_time, "reload_beard")

	tween.start()


func reload_beard():
	is_bearding = false
	
	var fade = $FadeTween
	
	fade.interpolate_property(self, "modulate", 
	    Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1, 
	    Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	
	fade.start()
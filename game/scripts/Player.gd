extends KinematicBody2D

onready var beard       = $Beard

onready var BEARD_POS   = beard.get_position()
onready var BEARD_SCALE = beard.get_scale()

var is_bearding = false
var beard_time  = 0.075



func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	look_at(mouse_pos)


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT and !is_bearding:
			self.fire(event.position)



func fire(mouse_pos):
	var sound = $WhipSound
	
	sound.set_pitch_scale(rand_range(0.95, 1.25))
	
	sound.play()
	
	
	var beard_scale = BEARD_SCALE
	var beard_pos   = beard.get_position()
	
	var distance   = get_viewport().get_mouse_position().distance_to(self.get_global_position())
	var dist_scale = distance / beard.get_texture().get_size().x


	var tween = $GunTween
	tween.interpolate_property(beard, "scale",
	                BEARD_SCALE, Vector2(dist_scale, BEARD_SCALE.y), beard_time,
	                Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
					
	tween.interpolate_callback(self, beard_time, "retract_beard", distance)

	tween.start()
	
	is_bearding = true


func retract_beard(distance):
	var tween = $GunTween

	tween.interpolate_property(beard, "scale",
	                beard.get_scale(), BEARD_SCALE, beard_time,
	                Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)

	tween.interpolate_callback(self, beard_time, "reload_beard")

	tween.start()

	
func reload_beard():
	is_bearding = false
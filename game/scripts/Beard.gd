extends Sprite

onready var beard       = $Beard

onready var BEARD_POS   = self.get_position()
onready var BEARD_SCALE = Vector2(self.get_scale().x, self.get_scale().y / 1.25)

var is_bearding = false
var beard_time  = 0.075


func _ready():
	set_modulate(Color(1, 1, 1, 0))


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT and !is_bearding:
			self.fire(event.position)


func fire(mouse_pos):
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
	
	var distance   = get_viewport().get_mouse_position().distance_to(self.get_global_position())
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
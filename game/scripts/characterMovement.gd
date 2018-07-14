extends KinematicBody2D

var speed = 5

var x = 0
var y = 0

var drag_margin_left = 0.3
var drag_margin_right = 0.7

var screen_size

var right_limit  = INF
var left_limit   = -INF
var bottom_limit = INF
var top_limit    = -INF


func _ready():
    screen_size = self.get_viewport_rect().size

func update_viewport():
    var canvas_transform = self.get_viewport().get_canvas_transform()
    canvas_transform.o   = -self.get_global_position() + screen_size / 2.0

    self.get_viewport().set_canvas_transform(canvas_transform)


func _physics_process(delta):
	var mouse_pos = $Cam.get_global_mouse_position()

	look_at(mouse_pos)

	x = 0
	y = 0

	if Input.is_action_pressed("ui_down"):
		y = 1

	if Input.is_action_pressed("ui_up"):
		y = -1

	if Input.is_action_pressed("ui_right"):
		x = 1

	if Input.is_action_pressed("ui_left"):
		x = -1

	var movement = Vector2(x, y).normalized()
	
	if movement.length() == 0:
		$Lowerbody.play("still")
	else:
		$Lowerbody.play("walking")

	move_and_collide(movement * speed)
	
	self.update_camera(self.get_position())


func update_camera(character_pos):
	var new_camera_pos = self.get_global_position()

	if character_pos.x > self.get_global_position().x + screen_size.x * (drag_margin_right - 0.5):
		new_camera_pos.x = character_pos.x - screen_size.x * (drag_margin_right - 0.5)
    
	elif character_pos.x < self.get_global_position().x + screen_size.x * (drag_margin_left - 0.5):
		new_camera_pos.x = character_pos.x + screen_size.x * (0.5 - drag_margin_left)
		
	
	var room_sprite = self.get_node("../Room")

	new_camera_pos.x = clamp(new_camera_pos.x, left_limit + screen_size.x * 0.5, right_limit - screen_size.x * 0.5)
	new_camera_pos.y = clamp(new_camera_pos.y, top_limit + screen_size.y * 0.5, bottom_limit - screen_size.y * 0.5)

	$Cam.set_global_position(new_camera_pos)
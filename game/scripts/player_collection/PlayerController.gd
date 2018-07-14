extends KinematicBody2D

var speed = 5

var dx = 0
var dy = 0

var friction = 10

var drag_margin_left = 0.3
var drag_margin_right = 0.7

var screen_size

var right_limit  = INF
var left_limit   = -INF
var bottom_limit = INF
var top_limit    = -INF
onready var sanity = $Sanity

var door


func _ready():
	screen_size = self.get_viewport_rect().size
	self.set_meta("type", "player")


func update_viewport():
	var canvas_transform = self.get_viewport().get_canvas_transform()
	canvas_transform.o   = -self.get_global_position() + screen_size / 2.0

	self.get_viewport().set_canvas_transform(canvas_transform)


func _physics_process(delta):
	var movement = self.do_movement()

	dx = lerp(dx, 0, delta * friction)
	dy = lerp(dy, 0, delta * friction)

	var collision = move_and_collide(movement)
	
	if collision:
		if "Door" in collision.collider.name:
			door = collision.collider.get_door()
			
			if door != collision.collider:
				self.set_rotation(door.get_rotation() - 90)
				self.set_position(door.get_position() - Vector2(cos(door.get_rotation() - 90), -1) * 0)
		else:
			if door:
				door.can_trigger = true
	else:
		if door:
			door.can_trigger = true
		
	do_mouse_look()

	self.update_camera(self.get_position())

func apply_damage(amount):
	#print("outch! On a scale from one to ten this is a solid " + str(amount))
	sanity.sanity_set(sanity.sanity_get() - amount)

func do_movement():
	var x = 0
	var y = 0

	if Input.is_action_pressed("ui_down"):
		dy = speed

	if Input.is_action_pressed("ui_up"):
		dy = -speed

	if Input.is_action_pressed("ui_right"):
		dx = speed

	if Input.is_action_pressed("ui_left"):
		dx = -speed

	var movement = Vector2(dx, dy)
	
	if movement.length() < 2:
		$Lowerbody.play("still")
	else:
		$Lowerbody.play("walking")
		
	return movement

func do_mouse_look():
	var mouse_pos = $Cam.get_global_mouse_position()

	look_at(mouse_pos)

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
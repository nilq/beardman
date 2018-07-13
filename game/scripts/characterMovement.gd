extends KinematicBody2D

var speed = 5

var x = 0
var y = 0


func _physics_process(delta):
	var mouse_pos = get_viewport().get_mouse_position()

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

	move_and_collide(Vector2(x, y).normalized() * speed)
extends KinematicBody2D

var _speed = 2;
var x = 0
var y = 0

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass
	
func _physics_process(delta):
	
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
	

func _process(delta):
	move(x, y);
	pass

# @param x,y -> determines the direction of movement by negative/positive integer. 0 is neutral
func move(x,y):
	var movement = Vector2(x*_speed, y*_speed)
	move_and_collide(movement)
	pass
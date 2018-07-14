extends KinematicBody2D

onready var player = get_node("../Player")

var damage = 5

func _ready():
	self.set_meta("type", "enemy")
	self.set_meta("variant", "cat")

func _process(delta):
	var player_position = player.get_position()
	look_at(player_position)
	
	var direction = player_position - self.get_position()
	
	var collision = move_and_collide(Vector2(0,0))
	
	if collision != null && collision.collider.has_meta("type") && collision.collider.get_meta("type") != "enemy":
		collision.collider.applyDamage(damage)
	
	#print(direction)
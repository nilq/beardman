extends CanvasLayer

onready var button = $MenuButton

func _ready():
	button.connect("pressed", self, "restart")
	
func restart():
	get_tree().change_scene("res://scenes/World.tscn")
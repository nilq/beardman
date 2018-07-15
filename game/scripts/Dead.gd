extends CanvasLayer

onready var button = $MenuButton

func _ready():
	button.connect("pressed", self, "restart")
	get_node("Number").set_text(str(Globals.highscore)) 
	
func restart():
	get_tree().change_scene("res://scenes/World.tscn")
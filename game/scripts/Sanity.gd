extends Node


var _sanityLevel = 100 setget sanity_set, sanity_get
var _sanityDrainRate = 0.5

var _SanityBarSizeX
var _SanityBarSizeY

onready var animation = $AnimationPlayer

func _ready():
	_SanityBarSizeX = $SanityContainer/SanityBar.rect_size.x
	_SanityBarSizeY = $SanityContainer/SanityBar.rect_size.y
	pass

func sanity_get():
	return _sanityLevel
	
func sanity_set(sanityLevel):
	_sanityLevel = sanityLevel
	
	if _sanityLevel < 0:
		get_tree().change_scene("res://scenes/Dead.tscn")
		
	if _sanityLevel > 100:
		_sanityLevel = 100

func _process(delta):
	_sanityLevel -= _sanityDrainRate * delta
	updateSanityBar()
	
func updateSanityBar():
	$SanityContainer/SanityBar.rect_size = Vector2(_SanityBarSizeX*(_sanityLevel/100),_SanityBarSizeY*1)
	
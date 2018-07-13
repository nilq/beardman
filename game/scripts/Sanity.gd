extends Node


var _sanityLevel = 100 setget sanity_set, sanity_get
var _sanityDrainRate = 3

var _SanityBarSizeX
var _SanityBarSizeY

func _ready():
	_SanityBarSizeX = $SanityContainer/SanityBar.rect_size.x
	_SanityBarSizeY = $SanityContainer/SanityBar.rect_size.y
	pass

func sanity_get():
	return _sanityLevel
	
func sanity_set(sanityLevel):
	_sanityLevel = sanityLevel

func _process(delta):
	_sanityLevel -= _sanityDrainRate * delta
	updateSanityBar()
	
func updateSanityBar():
	$SanityContainer/SanityBar.rect_size = Vector2(_SanityBarSizeX*(_sanityLevel/100),_SanityBarSizeY*1)
	get_tree().root.get_node()
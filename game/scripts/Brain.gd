extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var sanity_bar = self.get_node("..")

func _ready():
  # Called when the node is added to the scene for the first time.
  # Initialization here
  pass

func _process(delta):
  if sanity_bar._sanityLevel > 75:
    self.frame = 1
  elif sanity_bar._sanityLevel > 50:
    self.frame = 2
  elif sanity_bar._sanityLevel > 25:
    self.frame = 3
  else:
    self.frame = 4

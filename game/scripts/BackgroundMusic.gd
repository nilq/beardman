extends AudioStreamPlayer

onready var player = self.get_node("../../Rooooms/Player")

func _process():
  var mom = self.get_node("..").get_global_position()
  
  if mom.distance_to(player.get_global_position()) < 2000:
    self.play()
  else:
    self.pause()
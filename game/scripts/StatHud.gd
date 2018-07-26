extends CanvasLayer

var _score = 0
var _timeplayed = 0

func _ready():
	var timer = Timer.new()
	timer.set_wait_time(1)
	timer.connect("timeout", self, "increment_timeplayed")
	add_child(timer)
	timer.start()

## Getters and setters ##
func _set_score(value):
	_score += value
	Globals.highscore = _score

func _get_score():
	return _score

func _set_timeplayed(value):
	_timeplayed += value
	
func _get_timeplayed():
	return _timeplayed


func increment_timeplayed():
	_set_timeplayed(1)
	var minutes = _get_timeplayed() / 60
	var seconds = _get_timeplayed() % 60
	var elapsed = "%02d : %02d" % [minutes, seconds]
	get_node("TimePlayed").set_text("Playtime: " + elapsed)
	
func increment_score(value):
	_set_score(value)
	get_node("Score").set_text("Score: " + str(_get_score()))
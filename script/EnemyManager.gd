extends Node


var enemies = []

var timer = Timer.new()


var current_level_data:LevelData

func create_enemy(level_data:LevelData):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.one_shot = false
	timer.timeout.connect(time_out)
	add_child(timer)
	LevelManager.on_level_changed.connect(on_level_changed)
	pass # Replace with function body.

func on_level_changed(level_data:LevelData):
	current_level_data = level_data
	timer.start(level_data.tick)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func time_out():
	if current_level_data:
		current_level_data.create_enemy()
		pass

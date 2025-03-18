extends Node

const level_path = "res://resource/level/"

var current_level = 0
var enemies = []
signal on_level_changed(level_data:LevelData)


var level_data:Array[LevelData]

func new_level():
	current_level +=1
	on_level_changed.emit(level_data[current_level-1])
	pass

func stop():
	EnemyManager.timer.stop()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	var files=DirAccess.get_files_at(level_path)
	for file_name in files:
		level_data.append(load(level_path+ file_name))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

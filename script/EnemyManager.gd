extends Node


# 存活的敌人的数量
var still_alive_counts  = 0
#所击杀敌人的数量
var kill_counts = 0

signal handleEnemyCounts(changedCounts:int)
signal setFightInfoLabel(stillAliveEnemyCounts:int,killCounts:int)
func on_handleEnemyCounts(changedCounts:int):
	await get_tree().process_frame
	still_alive_counts=	enemies.size()
	if(changedCounts <0):
		kill_counts+=1
	setFightInfoLabel.emit(still_alive_counts,kill_counts)

	

var enemies = []

var timer = Timer.new()

signal on_enemy_death() 

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.one_shot = false
	timer.timeout.connect(time_out)
	add_child(timer)
	LevelManager.on_level_changed.connect(on_level_changed)
	
	handleEnemyCounts.connect(on_handleEnemyCounts)
	
	pass # Replace with function body.

func on_level_changed(level:int,enemy_counts_in_current_level:int,tick:float):
	timer.start(tick)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func check_enemies():
	if enemies.size() == 0:
		LevelManager.create_new_level()

	
func time_out():
	LevelManager.create_enemy()

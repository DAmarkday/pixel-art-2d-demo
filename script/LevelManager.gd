extends Node

var enemy:PackedScene  = preload("res://scene/enemy/Ghoul.tscn")
# 当前地图最大的敌人存活数量
const max_total_count_in_scene:int = 100
#敌人生成的时间间隔
const tick:float = 3

# 一次生成的数量
var once_count:int = 0
const once_count_ref = 2
# 最大一次生成的数量
const max_once_count:int = 10
# 在一波次中的几次生成敌人
const onces_counts_in_level = 3

# 当前波次
var current_level = 0
# 当前波次的敌人数量
var enemy_counts_in_current_level = 0
# 当前波次中已经生成的敌人数量
var created_enemy_counts_in_current_level = 0

signal on_level_changed(level:int,enemy_counts_in_current_level:int,tick:float)

func stop():
	EnemyManager.timer.stop()
	pass

func get_random_point():
	var map_land = Game.map.map_land as TileMapLayer
	
	var rect = map_land.get_used_rect() 
	#var area2D = Game.map.enemy_area as Area2D
	#var coll =area2D.get_node('CollisionShape2D') as CollisionShape2D
	#var rect = coll.shape.get_rect()
	
	var point = Vector2i(randi_range(rect.position.x,rect.position.x+ rect.size.x),randi_range(rect.position.y,rect.size.y + rect.position.y))
	#return rect.position + point 
	var point_2 = map_land.map_to_local( point)
	return point_2


func create_new_level():
	current_level +=1;
	created_enemy_counts_in_current_level = 0
	once_count = current_level * once_count_ref
	if(once_count>max_once_count):
		once_count = max_once_count
	
	enemy_counts_in_current_level = current_level * once_count * onces_counts_in_level
	if(enemy_counts_in_current_level >max_total_count_in_scene):
		enemy_counts_in_current_level = max_total_count_in_scene
	
	#create_enemy()	
	on_level_changed.emit(current_level,enemy_counts_in_current_level,tick)
	

func create_enemy():
	for i in once_count:
		if created_enemy_counts_in_current_level>=enemy_counts_in_current_level:
			LevelManager.stop()
			return
		var instance = enemy.instantiate()
		created_enemy_counts_in_current_level+=1
		instance.position = get_random_point()
		Game.map.add_child(instance)
		

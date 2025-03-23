extends Resource
class_name LevelData

@export var enemy:PackedScene 
@export var count:int
@export var tick:float
@export var once_count:int


var current_count  = 0

func create_enemy():
	for i in once_count:
		if current_count>=count:
			LevelManager.stop()
			return
		var instance = enemy.instantiate()
		#print(get_random_point())
		instance.position = get_random_point()
		
		Game.map.add_child(instance)
		current_count+=1
		
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
	


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

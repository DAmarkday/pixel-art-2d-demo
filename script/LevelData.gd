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
			return
		var instance = enemy.instantiate()
		#print(get_random_point())
		instance.global_position = get_random_point()
		
		Game.map.add_child(instance)
		current_count+=1
		
func get_random_point():
	var area2D = Game.map.enemy_area as Area2D
	var coll =area2D.get_node('CollisionShape2D') as CollisionShape2D
	var rect = coll.shape.get_rect()
	
	var point = Vector2(randf_range(-rect.size.x,rect.size.x),randf_range(-rect.size.y,rect.size.y))
	return rect.position + point 
	


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

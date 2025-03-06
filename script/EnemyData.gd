extends Resource
class_name EnemyData

@export var max_hp = 10 
@export var damage = 5

var current_hp:
	set(_value):
		current_hp = _value

func _init():
	current_hp = max_hp

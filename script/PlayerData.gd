extends Resource
class_name PlayerData

@export var max_hp = 10 
@export var damage = 5


@export var gold = 0

var current_hp:
	set(_value):
		current_hp = _value
		PlayerManager.on_player_hp_changed.emit(_value,max_hp)
		
		if current_hp <=0:
			PlayerManager.on_player_death.emit()
	

func _init():
	current_hp = max_hp

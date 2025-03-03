extends Resource
class_name PlayerData
@export var max_hp = 100 
@export var damage = 5


@export var gold = 0

var current_hp:
	set(_value):
		current_hp = _value
		PlayerManager.on_player_hp_changed.emit(_value,max_hp)
		pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

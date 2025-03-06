extends Node



var player_data:PlayerData

signal on_player_hp_changed(_current,_max)
signal on_player_death()
# Called when the node enters the scene tree for the first time.
func _ready():
	player_data = PlayerData.new()
	
	pass # Replace with function body.

func isDeath():
	if player_data:
		return player_data.current_hp <= 0
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

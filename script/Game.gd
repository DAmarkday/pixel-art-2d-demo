extends Node

var player:Player


func damage(origin:Node2D,target:Node2D):
	if origin is Player: 
		if target is BaseEnemy:
			target.enemy_data.current_hp -=PlayerManager.player_data.damage
	if origin is BaseEnemy: 
		if target is Player:
			PlayerManager.player_data.current_hp -=origin.enemy_data.damage
	
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

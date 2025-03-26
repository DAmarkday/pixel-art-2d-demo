extends Node

const _pre_weapon = preload("res://scene/weapon/Gun2.tscn")


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

signal on_weapon_changed(weapon:BaseWeapon)

func changeWeapon(weapon:BaseWeapon):
	var current_weapon = Game.player.weapon_node.get_child(0)
	if current_weapon:
		current_weapon.queue_free()
	Game.player.weapon_node.add_child(weapon)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("ui_accept"):
		changeWeapon(_pre_weapon.instantiate())
		pass


func _process(delta):
	pass
	
signal on_bullet_count_changed(_curr_bullets_per_magazine,_bullets_per_magazine,current_magazine_counts)
signal on_weapon_reload()

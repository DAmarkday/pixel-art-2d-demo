extends Node

var player_data:PlayerData
var player_cur_use_weapon:BaseWeapon


signal on_player_hp_changed(_current,_max)
signal on_player_death()

signal on_default_set_player_weapon(index:int,weapon:BaseWeapon)
signal on_weapon_change_instance(index:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	player_data = PlayerData.new()
	self.connect('on_default_set_player_weapon',func (index,weapon):
		player_cur_use_weapon = weapon
		on_weapon_change_instance.emit(index)
	)
	

func isDeath():
	if player_data:
		return player_data.current_hp <= 0
	return false

signal on_weapon_changed(weapon:BaseWeapon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _input(event):
	#if event.is_action_pressed("ui_accept"):
		#changeWeapon(_pre_weapon.instantiate())
		#pass
		
func _process(delta):
	if Input.is_action_just_pressed('weapon_1'):
		on_weapon_change_instance.emit(0)
		var current_weapon = Game.player.weapon_node.get_child(0)
		player_cur_use_weapon = current_weapon
	
	if Input.is_action_just_pressed('weapon_2'):
		on_weapon_change_instance.emit(1)
		var current_weapon = Game.player.weapon_node.get_child(1)
		player_cur_use_weapon = current_weapon
	
signal on_bullet_count_changed(_curr_bullets_per_magazine,_bullets_per_magazine,current_magazine_counts)
signal on_weapon_reload()

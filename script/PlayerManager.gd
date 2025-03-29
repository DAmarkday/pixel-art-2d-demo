extends Node

var player_data:PlayerData

signal on_player_hp_changed(_current,_max)
signal on_player_death()

signal on_default_set_player_weapon()
signal on_weapon_change_instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	player_data = PlayerData.new()
	self.connect('on_default_set_player_weapon',func (index):
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
	
	if Input.is_action_just_pressed('weapon_2'):
		on_weapon_change_instance.emit(1)
	
signal on_bullet_count_changed(_curr_bullets_per_magazine,_bullets_per_magazine,current_magazine_counts)
signal on_weapon_reload()

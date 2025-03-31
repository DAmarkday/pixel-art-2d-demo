extends CharacterBody2D
class_name Player

const SPEED = 50.0 
# 同步加载
const _pre_weapon = preload("res://scene/weapon/Gun2.tscn")
const _default_weapon = preload("res://scene/weapon/BaseWeapon.tscn")
const arr = [_default_weapon,_pre_weapon]
@onready var anim = $Body/AnimatedSprite2D
@onready var body = $Body
@onready var weapon_node = $Body/WeaponNode
@onready var camera=$Camera2D

var _current_anim = 'down_'

func on_init_player_weapon():
	if not is_instance_valid(weapon_node):
		push_error("weapon_node 未初始化或已被释放！")
		return
	for weapon in arr:
		print(weapon)
		if not weapon is PackedScene:
			push_error("无效的武器场景资源: ", weapon)
			continue
		var scene = weapon.instantiate()
		if not scene:
			push_error("场景实例化失败: ", weapon.resource_path)
			continue
		weapon_node.add_child(scene)
		print("武器已加载:", scene.weapon_name)
		
	await get_tree().process_frame
	PlayerManager.on_default_set_player_weapon.emit(0,weapon_node.get_child(0))
	

func _ready():
	Game.player = self
	PlayerManager.on_player_death.connect(on_player_death)
	
	on_init_player_weapon()
	
	PlayerManager.connect('on_weapon_change_instance',func (index):
		changeWeapon(index)
		)
		

func on_player_death():
	anim.play("death")
	weapon_node.hide()
	pass


func _physics_process(delta: float) -> void:
	if PlayerManager.isDeath():
		return 
	
	
	var dir = Vector2.ZERO
	dir.x = Input.get_axis("move_left","move_right")
	dir.y = Input.get_axis("move_up","move_down")
	
	velocity = dir.normalized() *SPEED
	
	changeAnim()
	
	move_and_slide()
	
func changeAnim():
	if velocity == Vector2.ZERO:
		anim.play(_current_anim + 'idle')
	else:
		_current_anim = get_movement_dir()
		anim.play(_current_anim + 'move')
		
	var _position = get_global_mouse_position()
	weapon_node.look_at(_position)
	
	if _position.x>position.x and body.scale.x !=1:
		body.scale.x = 1
	elif _position.x <position.x && body.scale.x !=-1:
		body.scale.x = -1
		
		
func get_movement_dir() ->String:
	weapon_node.z_index = 1
	if velocity == Vector2.ZERO:
		return 'lr_'
	
	var angle = velocity.angle()
	var degree = rad_to_deg(angle)
	
	if 45 <=degree and degree <135:
		return 'down_'
	elif -135 <=degree and degree <-45:
		weapon_node.z_index = 0
		return 'up_'

	
	return 'lr_'
	
func changeWeapon(weaponIndex:int):
	for index in range(arr.size()):
		var current_weapon = Game.player.weapon_node.get_child(index)
		if index == weaponIndex:
			if current_weapon:
				current_weapon.visible = true
				current_weapon.process_mode = Node.PROCESS_MODE_INHERIT
				PlayerManager.on_weapon_changed.emit(current_weapon)
				
				PlayerManager.on_bullet_count_changed.emit(current_weapon.current_bullet_count_in_single_magazine,current_weapon.bullets_per_magazine,current_weapon.current_magazine_counts)
			#pass
		else:
			#pass
			if current_weapon:
				current_weapon.visible = false
				current_weapon.process_mode = Node.PROCESS_MODE_DISABLED
	pass

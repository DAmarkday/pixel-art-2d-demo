extends Control

@onready var hp_bar = $HpControl/HpBar
@onready var bullet_label= $WeaponControl/Bullet
@onready var weapon_name_label = $WeaponControl/WeaponLabel
@onready var weapon_texture = $WeaponControl/TextureRect
@onready var cross = $TextureRect

@onready var levelInfo_label = $LevelInfo
@onready var killInfo_label = $KillInfo
@onready var enemyAliveInfolabel = $EnemyAliveInfo
@onready var enemyInfoInLevel_label = $EnemyInfoInLevel



# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.on_player_hp_changed.connect(on_player_hp_changed)
	
	PlayerManager.on_bullet_count_changed.connect(on_bullet_count_changed)
	PlayerManager.on_weapon_reload.connect(on_weapon_reload)
	PlayerManager.on_weapon_changed.connect(on_weapon_changed)
	LevelManager.on_level_changed.connect(on_level_changed)
	
	Game.on_game_start.connect(func ():
		Input.mouse_mode =Input.MOUSE_MODE_HIDDEN
		)
		
	EnemyManager.setFightInfoLabel.connect(func (stillAliveEnemyCounts:int,killCounts:int):
		enemyAliveInfolabel.text = '敌人剩余数: %s' %stillAliveEnemyCounts
		killInfo_label.text = '击杀数: %s' %killCounts
	)


func on_level_changed(level:int,enemy_counts_in_current_level:int,tick:float):
	levelInfo_label.text = '波次: %s' %LevelManager.current_level
	#enemyInfo_label.text = '敌人存活数量: %s' %LevelManager.still_alive_counts
	enemyInfoInLevel_label.text = '当前波次敌人总数: %s' %enemy_counts_in_current_level
	pass

func on_weapon_changed(weapon:BaseWeapon):
	weapon_name_label.text =weapon.weapon_name
	weapon_texture.texture = weapon.sprite.texture
	pass
	


func on_weapon_reload():
	Game.show_label(Game.player,"正在换弹中")
	bullet_label.text = '换弹中'
	pass
	


func on_bullet_count_changed(_curr_bullets_per_m,_bullets_per_magazine,_current_magazine_counts):
	bullet_label.text = '%s / %s / %s' %[_curr_bullets_per_m,_bullets_per_magazine,_current_magazine_counts]


func on_player_hp_changed(_current,_max):
	hp_bar.max_value = _max
	hp_bar.value = _current
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cross.position = get_global_mouse_position() - cross.size /2
	pass

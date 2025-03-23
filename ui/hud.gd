extends Control

@onready var hp_bar = $HpControl/HpBar
@onready var bullet_label= $WeaponControl/Bullet
@onready var weapon_name_label = $WeaponControl/WeaponLabel
@onready var weapon_texture = $WeaponControl/TextureRect
@onready var level_label = $Level
@onready var cross = $TextureRect

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
	
	
	pass # Replace with function body.

func on_level_changed(level_data):
	level_label.text = 'Level %s' %LevelManager.current_level
	pass

func on_weapon_changed(weapon:BaseWeapon):
	weapon_name_label.text =weapon.weapon_name
	weapon_texture.texture = weapon.sprite.texture
	pass
	


func on_weapon_reload():
	Game.show_label(Game.player,"正在换弹中")
	bullet_label.text = '换弹中'
	pass
	


func on_bullet_count_changed(_curr,_max):
	bullet_label.text = '%s / %s' %[_curr,_max]


func on_player_hp_changed(_current,_max):
	hp_bar.max_value = _max
	hp_bar.value = _current
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cross.position = get_global_mouse_position() - cross.size /2
	pass

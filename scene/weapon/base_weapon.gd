extends Node2D
class_name BaseWeapon

const _pre_bullet = preload("res://scene/bullet/BaseBullet.tscn")

@onready var bullet_point = $BulletPoint
@onready var audio2d = $AudioStreamPlayer2D
@onready var audio_reload = $AudioStreamPlayer2D2

@export var bullets_per_magazine = 30  # 每弹夹子弹数
@export var max_magazine_counts = 5 # 最大弹夹数量
@export var cur_total_bullets_counts = 150  # 当前子弹数量
@export var weapon_reload_rof= 0.42 # 武器换弹速度,数值越大换弹速度越慢

@export var damage = 5
@export var weapon_rof = 0.2
@export var weapon_name = '默认枪械'
@onready var fire_particles = $GPUParticles2D
var current_rof_tick = 0

const reload_audio = [
	"res://audio/wpn_reload_start.mp3",
	"res://audio/wpn_reload_end.mp3"
]

@onready var sprite = $Sprite2D

var current_bullet_count_in_single_magazine = 0 # 在当前弹夹中所有的子弹数量
var current_magazine_counts = 0 # 当前的弹夹数量

var player:Player

func _ready():
	fire_particles.lifetime = weapon_rof - 0.01
	
	# 设置当前所拥有的弹夹数量
	current_magazine_counts = cur_total_bullets_counts / bullets_per_magazine
	
	# 设置当前弹夹的子弹量
	var temp = cur_total_bullets_counts % bullets_per_magazine
	if temp ==0:
		current_magazine_counts -= 1
		current_bullet_count_in_single_magazine = bullets_per_magazine
	else:
		current_bullet_count_in_single_magazine = temp
	
	PlayerManager.on_weapon_changed.emit(self)
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count_in_single_magazine,bullets_per_magazine,current_magazine_counts)

func shoot():
	var instance = _pre_bullet.instantiate()
	instance.global_position = bullet_point.global_position
	instance.dir = global_position.direction_to(get_global_mouse_position())
	
	instance.current_weapon = self 
	get_tree().root.add_child(instance)
	
	current_bullet_count_in_single_magazine -=1
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count_in_single_magazine,bullets_per_magazine,current_magazine_counts)
	#if current_bullet_count_in_single_magazine <=0 && current_magazine_counts >0:
		#reload()
	weapon_anim()

func weapon_anim():
	fire_particles.restart()
	
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(sprite,'scale:x',0.7,weapon_rof / 2)
	tween.tween_property(sprite,'scale:x',1,weapon_rof / 2)
	if audio2d:
		audio2d.play()
	Game.camera_offset(Vector2(-1,2),weapon_rof)
	pass

func reload():
	audio_reload.stream = load(reload_audio[0])
	audio_reload.play()
	PlayerManager.on_weapon_reload.emit()
	await get_tree().create_timer(2 - weapon_reload_rof).timeout
	audio_reload.stream = load(reload_audio[1])
	audio_reload.play()
	
	await get_tree().create_timer(weapon_reload_rof).timeout 
	 
	current_bullet_count_in_single_magazine = bullets_per_magazine 
	current_magazine_counts -=1
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count_in_single_magazine,bullets_per_magazine,current_magazine_counts)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 更新节流计时器
	current_rof_tick +=delta
	if Input.is_action_pressed("fire") and current_rof_tick >= weapon_rof && current_bullet_count_in_single_magazine > 0:
			# 计时器归零时执行操作并重置计时器
		shoot()	
		current_rof_tick=0
		
	if Input.is_action_just_pressed("reload_weapon"):
		if  current_magazine_counts >0&& current_bullet_count_in_single_magazine<bullets_per_magazine:
			reload()
	pass

extends Node2D
class_name BaseWeapon

const _pre_bullet = preload("res://scene/bullet/BaseBullet.tscn")

@onready var bullet_point = $BulletPoint
@onready var audio2d = $AudioStreamPlayer2D

@export var bullet_max = 30
@export var damage = 5
@export var weapon_rof = 0.2
@export var weapon_name = '默认枪械'
@onready var fire_particles = $GPUParticles2D
var current_rof_tick = 0

@onready var sprite = $Sprite2D

var current_bullet_count = 0 

var player:Player

func _ready():
	fire_particles.lifetime = weapon_rof - 0.01
	current_bullet_count = bullet_max
	PlayerManager.on_weapon_changed.emit(self)
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count,bullet_max)

func shoot():
	var instance = _pre_bullet.instantiate()
	instance.global_position = bullet_point.global_position
	instance.dir = global_position.direction_to(get_global_mouse_position())
	
	instance.current_weapon = self 
	get_tree().root.add_child(instance)
	
	current_bullet_count -=1
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count,bullet_max)
	if current_bullet_count <=0:
		reload()
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
	PlayerManager.on_weapon_reload.emit()
	await get_tree().create_timer(2).timeout 
	current_bullet_count = bullet_max 
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count,bullet_max)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 更新节流计时器
	current_rof_tick +=delta
	if Input.is_action_pressed("fire") and current_rof_tick >= weapon_rof && current_bullet_count > 0:
			# 计时器归零时执行操作并重置计时器
		shoot()	
		current_rof_tick=0
	pass

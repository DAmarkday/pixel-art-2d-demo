extends Node2D
class_name BaseBullet

@export var speed = 500
@export var dir = Vector2.ZERO

const _pre_hit_effect = preload("res://scene/HitEffect.tscn")

var current_weapon:BaseWeapon

var _tick = 0
# physic默认在项目设置里是60帧，process就是实际游戏帧率
func _physics_process(delta):
	global_position += dir *delta*  speed
	_tick+=delta
	if Engine.get_physics_frames() % 20:
		if _tick>=3:
			queue_free()
			pass

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(get_global_mouse_position())
	pass # Replace with function body.



func _on_area_2d_body_entered(body):
	if body is BaseEnemy:
		Game.damage(Game.player,body)
		set_physics_process(false)
		
		var ins = _pre_hit_effect.instantiate()
		ins.global_position = global_position
		
		Game.map.add_child(ins)
		
		
		queue_free()

extends Node2D
class_name BaseWeapon

const _pre_bullet = preload("res://scene/bullet/BaseBullet.tscn")

@onready var bullet_point = $BulletPoint


# 节流间隔时间（秒）
var throttle_time := 0.1
var throttle_timer := 0.0

func shoot():
	var instance = _pre_bullet.instantiate()
	instance.global_position = bullet_point.global_position
	instance.dir = global_position.direction_to(get_global_mouse_position())
	get_tree().root.add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 更新节流计时器
	throttle_timer -= delta
	if Input.is_action_pressed("fire"):
		if throttle_timer <= 0:
			# 计时器归零时执行操作并重置计时器
			shoot()	
			throttle_timer = throttle_time
		
	pass

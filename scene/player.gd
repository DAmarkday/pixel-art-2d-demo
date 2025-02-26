extends CharacterBody2D


const SPEED = 50.0 
const JUMP_VELOCITY = -400.0

@onready var anim = $Body/AnimatedSprite2D
@onready var body = $Body

var _current_anim = 'down_'


func _physics_process(delta: float) -> void:
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
		body.scale.x = -1 if velocity.x <0 else 1
		
		
func get_movement_dir() ->String:
	if velocity == Vector2.ZERO:
		return 'lr_'
	
	var angle = velocity.angle()
	var degree = rad_to_deg(angle)
	
	if 45 <=degree and degree <135:
		return 'down_'
	elif -135 <=degree and degree <-45:
		return 'up_'
	return 'lr_'

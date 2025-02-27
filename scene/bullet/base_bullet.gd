extends Node2D
class_name BaseBullet

@export var speed = 500
@export var dir = Vector2.ZERO

func _physics_process(delta):
	global_position += dir *delta*  speed

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(get_global_mouse_position())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

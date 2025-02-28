extends CharacterBody2D
class_name BaseEnemy

@export var speed = 50


func _physics_process(delta):
	global_position = global_position.direction_to(Game.player.global_position) * speed *delta
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

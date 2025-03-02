extends CharacterBody2D
class_name BaseEnemy

@export var speed = 25

@onready var anim = $Body/AnimatedSprite2D
@onready var body = $Body

enum State {
	IDLE,
	MOVE,
	ATK,
	DEATH
}

var current_state = State.IDLE
var current_player = null

func _physics_process(delta):
	if(current_state == State.DEATH||current_state == State.ATK):
		return
	velocity = global_position.direction_to(Game.player.global_position) * speed
	move_and_slide()
	
	changeAnim()
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func changeAnim():
	if velocity == Vector2.ZERO:
		anim.play("idle")
		current_state = State.IDLE
	else:
		anim.play("move")
		current_state = State.MOVE
		body.scale.x = -1 if velocity.x<0 else 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_atk_area_body_entered(body):
	if body is Player:
		current_state = State.ATK
		current_player = body
		anim.play("atk")
	pass # Replace with function body.

func _on_atk_area_body_exited(body):
	if body is Player && body == current_player:
		current_player = null
	pass # Replace with function body.


func _on_animated_sprite_2d_frame_changed():
	if current_state ==State.ATK && anim.animation =='atk':
		if current_player&& anim.frame == 2:
			pass
	
	
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished():
	if current_state == State.ATK && anim.animation =='atk':
		if current_player:
			anim.play("atk")
		else:
			current_state = State.MOVE
	pass # Replace with function body.

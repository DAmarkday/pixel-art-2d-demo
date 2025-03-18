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

var enemy_data:EnemyData


func _physics_process(delta):
	if(current_state == State.DEATH||current_state == State.ATK):
		return
	if PlayerManager.isDeath():
		velocity = Vector2.ZERO
	else:
		velocity = global_position.direction_to(Game.player.global_position) * speed
	move_and_slide()
	
	changeAnim()
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_data = EnemyData.new()	
	EnemyManager.enemies.append(self)
	
	enemy_data.on_death.connect(on_death)
	pass # Replace with function body.

func on_death():
	current_state = State.DEATH
	anim.play('death')
	await anim.animation_finished
	queue_free()

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
	if body is Player and current_state != State.DEATH:
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
			Game.damage(self,current_player)
			pass
	
	
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished():
	if current_state == State.ATK && anim.animation =='atk':
		if current_player && PlayerManager.isDeath() == false:
			anim.play("atk")
		else:
			current_state = State.IDLE
	pass # Replace with function body.
	
func _exit_tree():
	EnemyManager.enemies.erase(self)
	EnemyManager.on_enemy_death.emit()
	EnemyManager.check_enemies()

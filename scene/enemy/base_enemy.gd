extends CharacterBody2D
class_name BaseEnemy

@export var speed = 25

@onready var anim = $Body/AnimatedSprite2D
@onready var body = $Body
@onready var coll =$CollisionShape2D
@onready var shadow = $Shadow 
@onready var hit_audio = $AudioStreamPlayer2D
@onready var nav = $NavigationAgent2D
enum State {
	IDLE,
	MOVE,
	ATK,
	DEATH,
	HIT
}

var current_state = State.IDLE
var current_player = null

var enemy_data:EnemyData

var movement_delta

var _tick = 0

func _physics_process(delta):
	if(current_state == State.DEATH||current_state == State.ATK ||current_state == State.HIT):
		return
	
	if NavigationServer2D.map_get_iteration_id(nav.get_navigation_map()) == 0:
		return
	if nav.is_navigation_finished():
		return

	movement_delta = speed
	var next_path_position: Vector2 = nav.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_delta
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)	
	
	move_and_slide()
	
	changeAnim()
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	_tick = randi_range(120,240)
	#nav.max_speed = speed
	enemy_data = EnemyData.new()	
	EnemyManager.enemies.append(self)
	
	enemy_data.on_hit.connect(on_hit)
	enemy_data.on_death.connect(on_death)
	
	EnemyManager.handleEnemyCounts.emit(1)
	pass # Replace with function body.

func on_hit(_damage):
	current_state = State.HIT
	
	Game.show_label(self,'-%s' %_damage)
	hit_audio.play()
	
	anim.play("hit")
	await anim.animation_finished
	current_state = State.IDLE
	pass


func on_death():
	if current_state == State.DEATH:
		return
	current_state = State.DEATH
	coll.call_deferred("set_disabled",true)
	shadow.hide()
	anim.play('death')
	await anim.animation_finished
	
	EnemyManager.handleEnemyCounts.emit(-1)
	queue_free()

func changeAnim():
	if velocity == Vector2.ZERO:
		anim.play("idle")
		current_state = State.IDLE
	else:
		anim.play("move")
		current_state = State.MOVE
		body.scale.x = -1 if !is_facing_target() and velocity.x <0 else 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.get_process_frames() % _tick == 0:
		set_movement_target(Game.player.global_position)
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

func set_movement_target(movement_targt:Vector2):
	nav.set_target_position(movement_targt)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if(current_state == State.DEATH||current_state == State.ATK ||current_state == State.HIT):
		return
	if PlayerManager.isDeath():
		velocity = Vector2.ZERO
	else:
		velocity = safe_velocity * speed * 50

	pass # Replace with function body.

func is_facing_target():
	var dir_to_target = (Game.player.global_position - global_position).normalized()
	var facing_dir = transform.x.normalized()
	
	var dot = facing_dir.dot(dir_to_target)
	return dot >= (1-0.7)
	pass

extends Node2D

@onready var canvas_layer=$CanvasLayer
@onready var enemy_area = $Area2D

const _player = preload("res://scene/player/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.map = self
	Game.on_game_start.connect(on_game_start)
	pass # Replace with function body.

func on_game_start():
	LevelManager.new_level()
	canvas_layer.show()
		
	var tween = create_tween()
	tween.parallel().tween_property(get_parent().color_rect,'modulate:a',0.0,0.2)
	
	tween.tween_callback(func ():
		get_parent().color_rect.hide()
	)
	
	var instance = _player.instantiate()
	add_child(instance)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

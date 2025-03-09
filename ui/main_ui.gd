extends Control

@onready var control = $Control
@onready var color_rect = $CanvasLayer/ColorRect
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	#get_tree().change_scene_to_file("res://scene/Main.tscn")
	start_game()
	pass # Replace with function body.

func start_game():
	color_rect.show()
	var tween = create_tween()
	tween.parallel().tween_property(color_rect,"modulate:a",1.0,0.2).from(0.0)
	tween.tween_callback(func ():
		control.hide()
		Game.on_game_start.emit()
		)

func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.

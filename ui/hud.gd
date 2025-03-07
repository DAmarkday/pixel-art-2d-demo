extends Control


@onready var hp_bar = $HpBar



# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.on_player_hp_changed.connect(on_player_hp_changed)
	pass # Replace with function body.

func on_player_hp_changed(_current,_max):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

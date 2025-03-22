extends Node2D



@onready var part = $GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	part.restart()
	await part.finished
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

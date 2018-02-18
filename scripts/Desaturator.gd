extends RigidBody2D

func _ready():
	get_node("/root/global").pos = position.x

func _process(delta):
	get_node("/root/global").pos = position.x
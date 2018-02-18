extends KinematicBody2D

export (int) var JUMP_SPEED = 400
export (int) var GRAVITY = 1000
export (int) var SPEED = 20

var velocity = Vector2()
var jumps = 1

onready var sprite = $AnimatedSprite

func _ready():
	sprite.play()

func _physics_process(delta):

	if !is_on_floor():
		velocity.y += delta * GRAVITY
	
	if $JumpTimer.time_left > 0 and is_on_floor() and jumps > 0:
			velocity.y = -JUMP_SPEED
			jumps = 0
	
	velocity.x = -SPEED
	
	move_and_slide(velocity,Vector2(0,-1))
	
	if get_slide_count() > 0:
		if get_slide_collision(0).collider is KinematicBody2D:
			if get_slide_collision(0).position.y < position.y+$col.position.y:
				queue_free()
			else:
				get_node("/root/global").health -= 1
				move_and_slide(Vector2(1000,1500),Vector2(0,-1))
	
	print(get_node("/root/global").health)

func _on_JumpTimer_timeout():
	jumps = 1

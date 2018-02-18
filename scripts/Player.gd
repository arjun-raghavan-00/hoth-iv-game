extends KinematicBody2D

export (int) var SPEED = 300
export (int) var JUMP_SPEED = 400
export (int) var GRAVITY = 1000

var velocity = Vector2()
var moving = false
var canDash = true
var jumps = 0
var dashspeed = 0

onready var sprite = $sprite
onready var anim = $animator

func _ready():
	get_node("/root/global").health = 3

func _physics_process(delta):
	
	if !sprite.scale.x < 0:
		dashspeed = 1
	else:
		dashspeed = -1
	
	if !is_on_floor():
		if jumps < 2:
			jumps = 1
		velocity.y += delta * GRAVITY
	if is_on_ceiling():
		velocity.y = 0
	
	var speed = 0
	
	if Input.is_action_pressed("ui_right"):
		moving = true
		speed += 1
	elif Input.is_action_pressed("ui_left"):
		moving = true
		speed -= 1
	else:
		moving = false
		velocity.x = lerp(velocity.x, 0, 0.1)
		
	if Input.is_action_just_pressed("game_jump") and (is_on_floor() or jumps < 2):
		velocity.y = -JUMP_SPEED
		jumps += 1
		
	if velocity.y > 0 and is_on_floor():
		jumps = 0
	
	speed *= SPEED
	
	if $dashtimer.is_stopped():
		canDash = true
	else:
		canDash = false
		
	if Input.is_action_just_pressed("game_dash") and canDash:
		velocity.x = lerp(velocity.x, dashspeed*SPEED*25, 0.1)
		anim.current_animation = "dash"
		$dashtimer.start()
		
	velocity.x = lerp(velocity.x, speed, 0.1)
	
	move_and_slide(velocity, Vector2(0, -1))
	
	sprite.scale.x = -1 if velocity.x < 0 else 1
	if anim.current_animation == "dash":
		anim.queue("run" if moving else "rest")
	else:
		anim.current_animation = "run" if moving else "rest"
		
	if Input.is_action_just_pressed("game_reset") or get_node("/root/global").pos > position.x or get_node("/root/global").health == 0:
		get_tree().reload_current_scene()
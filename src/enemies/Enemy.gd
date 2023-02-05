extends KinematicBody2D

onready var hitbox := $Hitbox
onready var pDetector := $PDetector
onready var aggroRange := $AggroRange
onready var jumpDelay := $JumpDelay

var velocity := Vector2.ZERO
var dir := Vector2(1,-1)
var speed := 25.0
var aggro_speed := 40
var is_aggro := false
var player:Player 
var dist_from_player:= Vector2.ZERO
var jump_speed := -100.0
var jump_up_limit:= 30.0
var jump_up_x_range = 5.0
var jump_delay_time = 0.5
var touching_root:= false
var gravity := 200.0
var jumping:= false
var climb_speed := 50.0


enum States {SEEKING,AGGRO,CLIMBING,FALLING}
var _state = States.SEEKING

func _ready() -> void:
	player = get_parent().get_node("Player")
	jumpDelay.connect("timeout",self,"jump_at_player")
	hitbox.connect("body_entered",self,"on_body_entered")
	hitbox.connect("area_entered",self,"on_hitbox_entered")
	pDetector.connect("area_entered",self,"on_pDetector_area_entered")
	aggroRange.connect("area_exited",self,"on_aggroRange_area_exited")
	jumpDelay.one_shot = true

func on_body_entered(body:PhysicsBody2D)-> void:
	prints(body)
	pass

func on_hitbox_entered(area:Area2D) -> void:
	if area.is_in_group("bounding-area") and _state != States.AGGRO:
		flip_dir()
	if area.is_in_group("rock"):
		die()
	if area.is_in_group("player"):
		area.get_parent().take_damage()

func on_pDetector_area_entered(area:Area2D):
	if area.is_in_group("player"):
		if _state != States.AGGRO:
			_state = States.AGGRO

func on_aggroRange_area_exited(area:Area2D):
	if area.is_in_group("player"):
			_state = States.SEEKING

func flip_dir():
	dir.x = dir.x * -1
	$PDetector/CollisionShape2D.position.x = 21 * dir.x
	$Sprite.flip_h = !$Sprite.flip_h
	pass

func die():
	#die
	pass

func _physics_process(delta: float) -> void:
	match _state:
		States.SEEKING:
			states_seeking(delta)
		States.AGGRO:
			states_aggro(delta)
		States.CLIMBING:
			states_climbing(delta)

func jump_at_player():		
	velocity.y = jump_speed
	jumping = false

func states_seeking(delta) -> void:
	climb()
	velocity.y += gravity * delta
	if not is_aggro:
		velocity.x = dir.x * speed
		move_and_slide(velocity,Vector2.UP)  
	if is_on_wall():
		flip_dir()


func states_aggro(delta) -> void:
	climb()
	velocity.y += gravity * delta
	dist_from_player = player.position - position
	if sign(dir.x) != sign(dist_from_player.x):
		flip_dir()
	# go back and write this but not afwul 
	if dist_from_player.y > -jump_up_limit and abs(dist_from_player.x) < jump_up_x_range and dist_from_player.y < 0:
		if not jumping and is_on_floor():
			jumping = true
			jumpDelay.wait_time = jump_delay_time		
			jumpDelay.start()
	velocity.x = dir.x * aggro_speed
	if jumping or not is_on_floor(): velocity.x = 0
	velocity = move_and_slide(velocity,Vector2.UP)  

func states_climbing(delta) -> void:
	velocity.x = 0
	velocity.y = climb_speed * dir.y
	if is_on_ceiling():
		dir.y = 1
	if not touching_root:
		_state = States.SEEKING
	move_and_slide(velocity, Vector2.UP)




func climb() -> void:
	if touching_root:
		_state = States.CLIMBING 
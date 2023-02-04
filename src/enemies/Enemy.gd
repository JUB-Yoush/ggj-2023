extends KinematicBody2D

onready var hitbox = $Hitbox
onready var pDetector = $PDetector
onready var aggroRange = $AggroRange
onready var jumpDelay = $JumpDelay

var velocity := Vector2.ZERO
var dir := Vector2(1,0)
var speed := 25.0
var aggro_speed := 40
var is_aggro := false
var player:Player 
var dist_from_player:= Vector2.ZERO
var jump_speed := -80.0
var jump_up_limit:= 30.0
var jump_up_x_range = 5.0
var jump_delay_time = 0.5
var gravity := 200.0
signal done_jump
# need to have predefined movement ranges
# use invisible bounding boxes to determine the range they can move between 
# if they notice a gap, try to jump across
# if they touch a root, start travleing on it (nearest path to player?)

func _ready() -> void:
	player = get_parent().get_node("Player")
	hitbox.connect("body_entered",self,"on_body_entered")
	hitbox.connect("area_entered",self,"on_hitbox_entered")
	pDetector.connect("area_entered",self,"on_pDetector_area_entered")
	aggroRange.connect("area_exited",self,"on_aggroRange_area_exited")

func on_body_entered(body:PhysicsBody2D)-> void:
	prints(body)
	pass

func on_hitbox_entered(area:Area2D) -> void:
	if area.is_in_group("bounding-area") and not is_aggro:
		flip_dir()
	if area.is_in_group("rock"):
		die()
	if area.is_in_group("player"):
		area.get_parent().take_damage()

func on_pDetector_area_entered(area:Area2D):
	if area.is_in_group("player"):
		if not is_aggro:
			is_aggro = true
func on_aggroRange_area_exited(area:Area2D):
	if area.is_in_group("player"):
		is_aggro = false

func flip_dir():
	dir.x = dir.x * -1
	$PDetector/CollisionShape2D.position.x = 21 * dir.x

	#FLIP THE DIRECTION IT'S GOING
	pass

func die():
	#die
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if not is_aggro:
		velocity = dir * speed
		velocity = move_and_slide(velocity)  
	else:
		dist_from_player = player.position - position
		if sign(dir.x) != sign(dist_from_player.x):
			flip_dir()
		# go back and write this but not afwul 
		#prints(dist_from_player.y > -jump_up_limit,abs(dist_from_player.x) < jump_up_x_range, sign(dist_from_player.y) == -1)
		if dist_from_player.y > -jump_up_limit and abs(dist_from_player.x) < jump_up_x_range and dist_from_player.y < 0:
			jump_at_player()
			yield(self,"done_jump")
		velocity.x = dir.x * aggro_speed
		velocity = move_and_slide(velocity)  
	if is_on_wall():
		flip_dir()

func jump_at_player():		
	print("readying jump")
	#start timer
	#yield till over
	#jump
	yield(get_tree().create_timer(jump_delay_time),"timeout")
	print("jumped")
	velocity.y = jump_speed
	emit_signal("done_jump")




			

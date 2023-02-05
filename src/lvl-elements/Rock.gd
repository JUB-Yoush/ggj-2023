extends Area2D

var speed := 2.0
var falling := false
var fall_delay:= .3


func _ready() -> void:
	connect("area_entered",self,"on_area_entered")

func _physics_process(delta: float) -> void:
	if falling:
		position.y += speed
		


func on_area_entered(area:Area2D) -> void:
	print("smthn touch rock")
	if area.is_in_group("player"):
		yield(get_tree().create_timer(fall_delay),"timeout")
		falling = true;
	



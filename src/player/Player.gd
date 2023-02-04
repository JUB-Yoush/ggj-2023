extends KinematicBody2D

var speed:= 10.0
var velocity:= Vector2.ZERO
var input_vector := Vector2.ZERO



func get_input() -> void:
    input_vector = Input.get_vector("left","right","up","down")

func _physics_process(delta: float) -> void:
    get_input()
    velocity.x = input_vector.x

    move_and_slide(velocity)
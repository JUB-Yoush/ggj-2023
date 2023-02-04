extends KinematicBody2D

# ---- child nodes ------
onready var hitbox = $Hitbox

var speed:= 50.0 
var velocity:= Vector2.ZERO
var input_vector := Vector2.ZERO
var jump_speed:= -80.0
var gravity := 200

enum States {
    ON_GROUND,
    IN_AIR,
    CLIMBING}

var _state = States.ON_GROUND

func _ready() -> void:
    hitbox.connect("area_entered",self,"on_hitbox_area_entered")
    

    pass

func _physics_process(delta: float) -> void:
    #simple state machine. I could do the non linear gdquest multinode setup but I have 2 days.
    match _state:
        States.ON_GROUND:
            state_on_ground(delta)
        States.IN_AIR:
            state_in_air(delta)
        States.CLIMBING:
            state_climbing(delta)

func change_state(new_state):
    # used to undo any state specific things we had goin' on
    match _state:
        States.ON_GROUND:
            pass
        States.IN_AIR:
            pass
        States.CLIMBING:
            pass
    _state = new_state

func state_on_ground(delta) -> void:
    get_input()
    velocity.x = input_vector.x * speed
    velocity.y += gravity * delta

    velocity = move_and_slide(velocity, Vector2.UP)

    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_speed
        change_state(States.IN_AIR)

func state_in_air(delta) -> void:
    get_input()
    velocity.y += gravity * delta
    velocity = move_and_slide(velocity, Vector2.UP)

    if is_on_floor():
        change_state(States.ON_GROUND)
    return

func state_climbing(delta) -> void:
    get_input()
    return

# ------------------------ STATE COMPONENTS ------------------------------------

func get_input() -> void:
    input_vector = Input.get_vector("left","right","up","down")


# ------ async methods (collisions and such)-----
func on_hitbox_area_entered(area:Area2D):
    if area.is_in_group("root") and input_vector.y < 0:
        change_state(States.CLIMBING)
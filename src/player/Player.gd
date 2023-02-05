extends KinematicBody2D
class_name Player
# ---- child nodes ------
onready var hitbox = $Hitbox

var speed:= 50.0 
var velocity:= Vector2.ZERO
var input_vector := Vector2.ZERO
var jump_speed:= -120.0
var jump_drift := 20.0
var gravity := 200.0
var climb_speed:= 70.0
var root_jump_vector = Vector2(150,10)
var touching_root := false

enum States {
    ON_GROUND,
    IN_AIR,
    CLIMBING}

var _state = States.ON_GROUND

func _ready() -> void:
    hitbox.connect("area_entered",self,"on_hitbox_area_entered")
    


func _physics_process(delta: float) -> void:
    #simple state machine. I could do the non linear gdquest multinode setup but I have 2 days.
    match _state:
        States.ON_GROUND:
            state_on_ground(delta)
        States.IN_AIR:
            state_in_air(delta)
        States.CLIMBING:
        # reset velo as approaching root
            velocity.x = 0
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
    jump()
    climb()
    velocity.x = input_vector.x * speed
    velocity.y += gravity * delta

    velocity = move_and_slide(velocity, Vector2.UP)

    if Input.is_action_just_pressed("jump"):
        velocity.y = jump_speed
        change_state(States.IN_AIR)

func state_in_air(delta) -> void:
    get_input()
    climb()
    velocity.y += gravity * delta
    var horizontal_influence := input_vector.x * jump_drift
    move_and_slide(Vector2(velocity.x + horizontal_influence, velocity.y)
, Vector2.UP)

    if is_on_floor():
        change_state(States.ON_GROUND)
    return

func state_climbing(delta) -> void:
    get_input()
    jump()
    velocity.y = input_vector.y * climb_speed 
    velocity = move_and_slide(velocity)
    if not touching_root:
        change_state(States.IN_AIR)
        



# ------------------------ STATE COMPONENTS ------------------------------------

func get_input() -> void:
    input_vector = Input.get_vector("left","right","up","down")

func climb() -> void:
    if touching_root and input_vector.y == -1:
        change_state(States.CLIMBING)

func jump() -> void:
    if Input.is_action_just_pressed("jump"):
        if _state == States.CLIMBING:
             velocity.y = root_jump_vector.y 
             velocity.x = root_jump_vector.x * input_vector.x
        else:
            velocity.y = jump_speed
        change_state(States.IN_AIR)

# ------ async methods (collisions and such)-----
func on_hitbox_area_entered(area:Area2D):
    if area.is_in_group("enemy"):
        get_tree().reload_current_scene() 
    pass

func take_damage():
    pass
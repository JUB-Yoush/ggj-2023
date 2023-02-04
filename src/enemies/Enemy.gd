extends KinematicBody2D

onready var hitbox = $Hitbox
onready var pDetector = $PDetector

var velocity := Vector2.ZERO
var dir := Vector2(1,0)
var speed := 25.0
var aggro_speed := 40
var is_aggro := false

# need to have predefined movement ranges
# use invisible bounding boxes to determine the range they can move between 
# if they notice a gap, try to jump across
# if they touch a root, start travleing on it (nearest path to player?)

func _ready() -> void:
    hitbox.connect("area_entered",self,"on_hitbox_entered")
    pDetector.connect("area_entered",self,"on_pDetector_area_entered")

func on_hitbox_entered(area:Area2D) -> void:
    if area.is_in_group("bounding-area"):
        flip_dir()
    if area.is_in_group("rock"):
        die()
    if area.is_in_group("player"):
        area.get_parent().take_damage()

func on_pDetector_area_entered(area:Area2D):
    if not is_aggro:
        is_aggro = true

func flip_dir():
    #FLIP THE DIRECTION IT'S GOING
    pass

func die():
    #die
    pass

func _physics_process(delta: float) -> void:
    if not is_aggro:
       velocity = dir * speed
       velocity = move_and_slide(velocity)  
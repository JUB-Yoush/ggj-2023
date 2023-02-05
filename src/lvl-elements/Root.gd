extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered",self,"on_area_entered")
	connect("area_exited",self,"on_area_exited")



func on_area_entered(area:Area2D)-> void:
	if area.is_in_group("player") or area.is_in_group("enemy"): 
		area.get_parent().touching_root = true


func on_area_exited(area:Area2D)-> void:
	if area.is_in_group("player") or area.is_in_group("enemy"): 
		area.get_parent().touching_root = false 

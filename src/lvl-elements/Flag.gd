extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered",self,"flag_hit")

func flag_hit(area:Area2D):
	print("flag hit")
	if area.is_in_group("player"):
		get_tree().change_scene("res://src/end.tscn")


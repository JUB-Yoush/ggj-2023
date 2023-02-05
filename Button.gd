extends Button

func _ready() -> void:
	connect("pressed", self,"start_game")

func start_game():
	get_tree().change_scene("res://src/levels/Level0.tscn")

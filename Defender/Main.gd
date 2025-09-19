extends Node3D


var score = 0


@onready var playerlocation = get_node("Player").get_global_position()


func _process(delta):
	playerlocation = get_node("Player").get_global_position()
	

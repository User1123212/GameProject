extends RigidBody3D

class_name DroppedItem

@export var Gun : Resource

func _ready():
	var GunInstance = Gun.BlendModel.instantiate()
	GunInstance.rotate_x(PI/2)
	add_child(GunInstance)
	

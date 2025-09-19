extends Resource


class_name FullAuto

@export var name : String
@export var FireRate : float
@export var Damage : int
@export var Model : PackedScene
@export var Animations : AnimationLibrary
@export var BlendModel: PackedScene
@export var ReloadSpeed: float
@export var Ammo: int



var bullet = preload("res://Player/Bullet.tscn")

var CurrentAmmo = Ammo

func use(Player):
	CurrentAmmo -= 1
	var copy = bullet.instantiate()
	copy.position = Player.position + Vector3(0,1.6,0)
	copy.rotation = Player.rotation
	copy.rotation.x = Player.get_node("Pivot/PlayerEyes").rotation.x
	copy.BULLET_DAMAGE = Damage
	Player.get_parent().add_child(copy)

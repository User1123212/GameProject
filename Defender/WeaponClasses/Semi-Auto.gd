extends Resource

class_name SemiAuto


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

#I think raycasting is the way to go
func use(Player):
	if Input.is_action_just_pressed("shoot"):
		
		CurrentAmmo -= 1
		var gunpoint = Player.get_node("Pivot/PlayerEyes/Gunpoint")
		gunpoint.force_raycast_update()
		
		if gunpoint.is_colliding():
			var body = gunpoint.get_collider()
			
			if body == null:
				pass
			elif body.has_method("bullet_hit"):
				body.bullet_hit(Damage, gunpoint.global_transform)
				
		
		

extends CharacterBody3D

var speed = 5
const BASE_BULLET_BOOST = .1;
var hp = 20

@onready var Main = self.get_parent()

func bullet_hit(damage, bullet_global_trans):
	var direction_vect = bullet_global_trans.basis.z.normalized() * BASE_BULLET_BOOST;
	speed -= speed*BASE_BULLET_BOOST
	hp -= damage
	Main.score += 10
	if hp <= 0:
		Main.score += 50
		self.queue_free()





func _physics_process(delta):
	var movementvector = get_parent().playerlocation - self.position
	velocity = movementvector.normalized() * speed
	velocity.y = 0
	
	move_and_slide()
	
	look_at(get_parent().playerlocation)

func _process(delta):
	if velocity != Vector3(0,0,0):
		get_node("AnimationPlayer").play("Walk")

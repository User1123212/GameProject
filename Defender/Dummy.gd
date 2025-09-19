extends RigidBody3D


const BASE_BULLET_BOOST = 1;

var hp = 200


func bullet_hit(damage, bullet_global_trans):
	var direction_vect = bullet_global_trans.basis.z.normalized() * BASE_BULLET_BOOST;

	apply_impulse((bullet_global_trans.origin - global_transform.origin).normalized(), direction_vect * damage *20)
	hp -= damage
	if hp <= 0:
		self.queue_free()

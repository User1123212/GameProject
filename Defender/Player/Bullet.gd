extends Node3D

@onready var Main = get_parent()

var BULLET_SPEED = 100
var BULLET_DAMAGE = 15
var BULLET_POINTS = 10

const KILL_TIMER = 4
var timer = 0

var hit_something = false



signal enemy_hit


func _physics_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(-forward_dir * BULLET_SPEED * delta)

	timer += delta
	if timer >= KILL_TIMER:
		queue_free()



func _on_bullet_hitbox_body_entered(body):
	if hit_something == false:
		if body.has_method("bullet_hit"):
			body.bullet_hit(BULLET_DAMAGE, global_transform)
			Main.score += 10
		hit_something = true
		queue_free()

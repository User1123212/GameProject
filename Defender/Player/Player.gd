extends CharacterBody3D


var bullet = preload("res://Player/Bullet.tscn")
var DropItem = preload("res://Weapons/ItemDrop.tscn")

@onready var Main = get_node("/root/Main")

var gravity = -30
var maxSpeed = 10
var jumpStrength = 20
var mouseSensitivity = -.002
var movement = false
var count = 0
var reloading = false


var ScarH = preload("res://Weapons/ScarH.tres")
var M1911 = preload("res://Weapons/M1911.tres")


#inventory stuff
var inventory = [M1911,null]
var WeapInd = 0
var activeWeapon = inventory[WeapInd]



func get_input():
	#movement controls
	var inputDir = Vector3()
	if Input.is_action_pressed("moveForwards"):
		inputDir += -global_transform.basis.z
		movement = true
	if Input.is_action_pressed("moveBackwards"):
		inputDir += global_transform.basis.z
		movement = true
	if Input.is_action_pressed("moveLeft"):
		inputDir += -global_transform.basis.x
		movement = true
	if Input.is_action_pressed("moveRight"):
		inputDir += global_transform.basis.x
		movement = true
		
		
	if Input.is_action_just_pressed("jump") and is_on_floor() == true:
		inputDir += global_transform.basis.y
		movement = false
	if Input.is_action_pressed("sprint"):
		maxSpeed = 20
	if Input.is_action_just_released("sprint"):
		maxSpeed = 10
	inputDir = inputDir.normalized()
	return inputDir

	


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if activeWeapon != null:
		get_node("Pivot/PlayerEyes/WeaponSlot").add_child(activeWeapon.BlendModel.instantiate())
	

		
func _physics_process(delta):
	
	#movement and velocity
		
		var desiredVelocity = get_input()*maxSpeed 
		velocity.x = desiredVelocity.x
		velocity.z = desiredVelocity.z
		velocity.y += gravity * delta + (get_input()*jumpStrength).y
		
		if is_on_wall() == true:
			gravity = 0
		if is_on_wall() == false:
			gravity = -30
			
			
		move_and_slide()
		
func _process(delta):
		
	if velocity.y !=0:
		movement = false
	if velocity.x == 0 and velocity.z == 0:
		movement = false
	
	if movement == true:
		count += delta
		get_node("Pivot/PlayerEyes").translate(Vector3(0,.05*cos(20*count),0))
		get_node("Pivot/PlayerEyes/WeaponSlot").translate(Vector3(0,.02*sin(20*count),0))
	if movement == false:
		count = 0
		get_node("Pivot/PlayerEyes").position.y = 0
		get_node("Pivot/PlayerEyes/WeaponSlot").position.y = -.7


	#nonmovement controls
	if Input.is_action_pressed("shoot") and activeWeapon != null and get_node("ShotTimer").time_left == 0:
		get_node("ShotTimer").set_wait_time(activeWeapon.FireRate)
		get_node("ShotTimer").start()
		if activeWeapon.CurrentAmmo <= 0:
			get_node("ShotTimer").set_wait_time(activeWeapon.ReloadSpeed)
			get_node("ShotTimer").start()
			
			reloading = true
		if activeWeapon.CurrentAmmo > 0:
			activeWeapon.use(self)
			#get_node("Pivot/PlayerEyes/WeaponSlot").get_child(0).get_node("AnimationPlayer").play("Shoot")
		print(activeWeapon.CurrentAmmo)
		
		
			
			
		
		
	if Input.is_action_just_pressed("Active1"):
		WeapInd = 0
		activeWeapon = inventory[WeapInd]
		get_node("ShotTimer").set_wait_time(.5)
		get_node("ShotTimer").start()
		reloading = false
		if get_node("Pivot/PlayerEyes/WeaponSlot").get_child(0) != null:
			get_node("Pivot/PlayerEyes/WeaponSlot").get_child(0).queue_free()
		if activeWeapon != null:
			get_node("Pivot/PlayerEyes/WeaponSlot").add_child(activeWeapon.BlendModel.instantiate())
		
	if Input.is_action_just_pressed("Active2"):
		WeapInd = 1
		activeWeapon = inventory[WeapInd]
		get_node("ShotTimer").set_wait_time(.5)
		get_node("ShotTimer").start()
		reloading = false
		if get_node("Pivot/PlayerEyes/WeaponSlot").get_child(0) != null:
			get_node("Pivot/PlayerEyes/WeaponSlot").get_child(0).queue_free()
		if activeWeapon != null:
			get_node("Pivot/PlayerEyes/WeaponSlot").add_child(activeWeapon.BlendModel.instantiate())
			
			
	if Input.is_action_just_pressed("Interact"):
		var PlayerRay = get_node("Pivot/PlayerEyes/PlayerRay")
		PlayerRay.add_exception(self)
		PlayerRay.set_enabled(true)
		
		if PlayerRay.get_collider() != null:
			print(PlayerRay.get_collider())
			if PlayerRay.get_collider().is_in_group("Item"):
				
				#pickup and drop 
				if inventory[0] != null and inventory[1] != null:
					var LeavingGun = DropItem.instantiate()
					LeavingGun.Gun = activeWeapon
					get_node("/root").add_child(LeavingGun)
					LeavingGun.position = self.position + Vector3(1,1,1)
					inventory.remove_at(WeapInd)
					inventory.insert(WeapInd, PlayerRay.get_collider().Gun)
					activeWeapon = inventory[WeapInd]
					PlayerRay.get_collider().queue_free()
					PlayerRay.set_enabled(false)
					get_node("Pivot/PlayerEyes/WeaponSlot").get_child(0).queue_free()
					get_node("Pivot/PlayerEyes/WeaponSlot").add_child(activeWeapon.BlendModel.instantiate())
				if inventory[0] != null and inventory[1] == null:
					inventory.remove_at(1)
					inventory.insert(1, PlayerRay.get_collider().Gun)
					PlayerRay.get_collider().queue_free()
					if WeapInd == 1:
						activeWeapon = PlayerRay.get_collider().Gun
						get_node("Pivot/PlayerEyes/WeaponSlot").add_child(activeWeapon.BlendModel.instantiate())
					PlayerRay.set_enabled(false)
				if inventory[0] == null and inventory[1] != null:
					inventory.remove_at(0)
					inventory.insert(0, PlayerRay.get_collider().Gun)
					PlayerRay.get_collider().queue_free()
					if WeapInd == 0:
						activeWeapon = PlayerRay.get_collider().Gun
						get_node("Pivot/PlayerEyes/WeaponSlot").add_child(activeWeapon.BlendModel.instantiate())
					PlayerRay.set_enabled(false)
				if inventory[0] == null and inventory[1] == null:
					inventory.remove_at(0)
					inventory.insert(0, PlayerRay.get_collider().Gun)
					PlayerRay.get_collider().queue_free()
					PlayerRay.set_enabled(false)
					activeWeapon = PlayerRay.get_collider().Gun
					get_node("Pivot/PlayerEyes/WeaponSlot").add_child(activeWeapon.BlendModel.instantiate())
			if PlayerRay.get_collider().is_in_group("Door") and (Main.score - PlayerRay.get_collider().price) >= 0:
				Main.score -= PlayerRay.get_collider().price
				PlayerRay.get_collider().queue_free()
					
					
	
	var textScore = str(Main.score)
	get_node("Pivot/PlayerEyes/HUD/ScoreLabel").text = textScore

	if activeWeapon != null:
		var textAmmo = str(activeWeapon.CurrentAmmo)
		get_node("Pivot/PlayerEyes/HUD/AmmoCounter").text = textAmmo
	if activeWeapon == null:
		get_node("Pivot/PlayerEyes/HUD/AmmoCounter").text = " "
			
func _unhandled_input(event):
	#controls rotation of camera up and down
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(event.relative.x * mouseSensitivity)
		$Pivot/PlayerEyes.rotate_x(event.relative.y * mouseSensitivity)
		$Pivot/PlayerEyes.rotation.x = clamp($Pivot/PlayerEyes.rotation.x, -1.4, 1.4)
		
		


func _on_shot_timer_timeout():
	if reloading == true and activeWeapon != null:
		activeWeapon.CurrentAmmo = activeWeapon.Ammo
		reloading = false

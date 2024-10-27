extends CharacterBody2D

var SPEED = 100.0
var JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var paperbag: Area2D = $"../paperbag"

var enemy_in_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false

#call: animationSet($Inventory.
func animationSet(item_name, motion):
	if item_name == "jack":
		if motion == "idle":
			return "jack_idle"
		elif motion == "attack":
			return "jack_attack"
		elif motion == "walk":
			return "jack_walk"
		elif motion == "jump":
			return "jack_jump"
		elif motion == "hurt":
			return "jack_hurt"
		elif motion == "die":
			return "jack_die"
		
	elif item_name == "bag":
		if motion == "idle":
			return "bag_idle"
		elif motion == "attack":
			return "bag_attack"
		elif motion == "walk":
			return "bag_walk"
		elif motion == "jump":
			return "bag_jump"
		elif motion == "hurt":
			return "bag_hurt"
		elif motion == "die":
			return "bag_die"
		
	else:
		if motion == "idle":
			return "candle_idle"
		else: #motion == "walk":
			return "candle_walk"
			


func _physics_process(delta: float) -> void:
	if $Inventory.currentItem == "bag":
		JUMP_VELOCITY = -550
		SPEED = 200
	else:
		JUMP_VELOCITY = -300
		SPEED = 100
	enemy_attack()
	player_attack()
	#if paperbag.pickedUp():
		#animationSet("bag","idle")
		#$Inventory.currentItem = "bag"
	if health <= 0:
		#$AnimatedSprite2D.play("death")
		health = 0
		player_alive = false
	if not is_on_floor():
		velocity += get_gravity() * delta
# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
#Get the input direction 1, 0 -1
	var direction := Input.get_axis("move_left", "move_right")

#flip the sprite
	if direction>0:
		animated_sprite.flip_h = false
	elif direction <0:
		animated_sprite.flip_h = true

	if attack_ip:
		if not animated_sprite.is_playing():
			attack_ip = false
	elif is_on_floor():
		if direction == 0:
			animated_sprite.play(animationSet($Inventory.currentItem, "idle"))
			
		elif direction:
			animated_sprite.play(animationSet($Inventory.currentItem, "walk"))
	else:
		animated_sprite.play(animationSet($Inventory.currentItem, "jump"))
	#play animation

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	
func player_move(delta):
	if Input.is_action_just_pressed("move_left"):
		velocity.x = -SPEED
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play(animationSet($Inventory.currentItem, "walk"))
	elif Input.is_action_just_pressed("move_right"):
		velocity.x = SPEED
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play(animationSet($Inventory.currentItem, "walk"))
	elif attack_ip == false:
		velocity.x = 0
		$AnimatedSprite2D.play(animationSet($Inventory.currentItem, "idle"))
			
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("eyeball") or body.has_method("mushroom"):
		enemy_in_range = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("eyeball") or body.has_method("mushroom"):
		enemy_in_range = false
		
func enemy_attack():
	if enemy_in_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attackCD.start()
		print(health)

func player():
	pass

func _on_attack_cd_timeout() -> void:
	enemy_attack_cooldown = true

func player_attack():
	var dir = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == 1:
			animated_sprite.flip_h = false
			animated_sprite.play(animationSet($Inventory.currentItem, "attack"))
			if $Inventory.currentItem != "nothing":
				$DealAttackCD.start()
		if dir == -1:
			animated_sprite.flip_h = true
			animated_sprite.play(animationSet($Inventory.currentItem, "attack"))
			if $Inventory.currentItem != "nothing":
				$DealAttackCD.start()
		if dir == 0:
			animated_sprite.play(animationSet($Inventory.currentItem, "attack"))
			if $Inventory.currentItem != "nothing":
				$DealAttackCD.start()
			

func _on_deal_attack_cd_timeout() -> void:
	if $Inventory.currentItem != "nothing":
		$DealAttackCD.stop()
	global.player_current_attack = false
	attack_ip = false

extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var enemy_in_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var player_hit = false

var attack_ip = false
var hit_ip = false
func _ready():
	print("start")

func _physics_process(delta: float) -> void:
	enemy_attack()
	if !player_alive:
		$AnimatedSprite2D.play("death")
	else:
		player_attack()
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
		
		if hit_ip:
			if not animated_sprite.is_playing():
				hit_ip = false
		elif attack_ip:
			if not animated_sprite.is_playing():
				attack_ip = false
		elif is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			elif direction:
				animated_sprite.play("walking")
		else:
			animated_sprite.play("jumping")
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
		$AnimatedSprite2D.play("walking")
	elif Input.is_action_just_pressed("move_right"):
		velocity.x = SPEED
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("walking")
	elif attack_ip == false:
		velocity.x = 0
		$AnimatedSprite2D.play("idle")
			
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
		if health-20 > 0:
			$AnimatedSprite2D.play("hurt")
			$RecieveAttackCD.start()
			player_hit = true
			hit_ip = true
			health = health - 20
		else:
			health = 0
			player_alive = false
		enemy_attack_cooldown = false
		$attackCD.start()
		print("player: ", health)

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
			animated_sprite.play("attack")
			$DealAttackCD.start()
		if dir == -1:
			animated_sprite.flip_h = true
			animated_sprite.play("attack")
			$DealAttackCD.start()
		if dir == 0:
			animated_sprite.play("attack")
			$DealAttackCD.start()

func _on_deal_attack_cd_timeout() -> void:
	$DealAttackCD.stop()
	global.player_current_attack = false
	attack_ip = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if !player_alive:
		get_tree().reload_current_scene()

func _on_recieve_attack_cd_timeout() -> void:
	$RecieveAttackCD.stop()
	player_hit = false
	hit_ip = false

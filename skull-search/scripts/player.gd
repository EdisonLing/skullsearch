extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var enemy_in_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false

func _physics_process(delta: float) -> void:
	enemy_attack()
	player_attack()
	if health <= 0:
		#$AnimatedSprite2D.play("death")
		health = 0
		player_alive = false
	player_move(delta)
	
	
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
			animated_sprite.play("attack")
			$DealAttackCD.start()
		if dir == -1:
			animated_sprite.flip_h = true
			animated_sprite.play("attack")
			$DealAttackCD.start()
			

func _on_deal_attack_cd_timeout() -> void:
	$DealAttackCD.stop()
	global.player_current_attack = false
	attack_ip = false

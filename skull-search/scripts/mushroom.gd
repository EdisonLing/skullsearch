extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null

var health = 50
var player_in_range = false
#var player_atk_cd = true
var hit = false;
var hit_ip = false;
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		position.y = position.y + 5
	if health == 0:
		$AnimatedSprite2D.play("death")
	else:
		damage()
		if player_chase:
			position += (player.position - position)/speed
			if(player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		
		if hit_ip:
			if not animated_sprite.is_playing():
				hit_ip = false
		elif player_in_range == true:
			$AnimatedSprite2D.play("attack")
		elif player_chase:
			$AnimatedSprite2D.play("walking")
		else:
			$AnimatedSprite2D.play("idle")
		move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	
func eyeball():
	pass


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false
		
func damage():
	if player_in_range and global.player_current_attack:# and player_atk_cd:
		if health-25 > 0:
			print("hit1")
			$AnimatedSprite2D.play("hurt")
			$RecieveAttackCD.start()
			hit = true
			hit_ip = true
			health = health - 25
		else:
			print("hit2")
			print("dying")
			health = 0
		global.player_current_attack = false
		$attackCD.start()
		print("shroom: ", health)

func _on_recieve_attack_cd_timeout() -> void:
	$RecieveAttackCD.stop()
	hit = false
	hit_ip = false
	

func _on_attack_cd_timeout() -> void:
	global.player_current_attack = true

func _on_animated_sprite_2d_animation_finished() -> void:
	print("shroom dead")
	if health == 0:
		queue_free()

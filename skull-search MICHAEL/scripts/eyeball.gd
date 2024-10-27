extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null

var health = 50
var player_in_range = false


func _physics_process(delta: float) -> void:
	damage()
	if player_chase:
		position += (player.position - position)/speed
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
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
	if player_in_range and global.player_current_attack == true:
		health = health - 25
		print(health)
		if health <= 0:
			$AnimatedSprite2D.play("death")
			

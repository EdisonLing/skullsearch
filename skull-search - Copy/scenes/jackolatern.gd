extends Area2D

func _on_body_entered(body: Node2D) -> void:
	%Inventory2.items["jack"] = 1
	%Inventory2.switchCurrentItem("jack")
	$"../CanvasLayer/Hotbar/AnimatedSprite2D".visible = true
	queue_free()

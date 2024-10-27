extends Area2D

@onready var inventory: Node2D = %Inventory2

func _on_body_entered(body: Node2D) -> void:
	%Inventory2.items["bag"] = 1
	%Inventory2.switchCurrentItem("bag")
	$"../CanvasLayer/Hotbar/AnimatedSprite2D2".visible = true
	queue_free()

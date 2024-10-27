extends Area2D
var status = false
signal pickedUp(status)

func _on_body_entered(body: Node2D) -> void:
	status = true
	pickedUp.emit()

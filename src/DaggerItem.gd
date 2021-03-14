extends Area2D




func _on_DaggerItem_body_entered(body):
	if body.is_in_group("players"):
		body.has_daggers = true

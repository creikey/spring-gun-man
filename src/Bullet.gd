extends Area2D

const speed: float = 500.0

func _physics_process(delta):
	global_position += Vector2(speed, 0).rotated(rotation)*delta


func _on_Bullet_body_entered(body):
	if body.is_in_group("walls"):
		queue_free()

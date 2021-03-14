extends KinematicBody2D

const _gravity: float = 2000.0
const _lowered_jump_gravity: float = 1200.0
const _shoot_velocity: float = 600.0
var _velocity := Vector2()

var _bullets: int = 0

onready var _spring = $Spring

var _lowered_gravity: bool = false

func _shoot():
	if _bullets <= 0:
		_bullets = 0
		return
	var vel: float = _shoot_velocity
	_velocity -= (get_global_mouse_position() - global_position).normalized() * vel
	_bullets -= 1
	var new_bullet = preload("res://Bullet.tscn").instance()
	get_parent().add_child(new_bullet)
	new_bullet.global_position = global_position
	new_bullet.rotation = global_position.angle_to_point(get_global_mouse_position()) + PI
	

func _input(event):
	if event is InputEventMouseMotion:
		pass
#		rotation -= event.relative.x*0.005
#		var x_diff: float = event.relative.x
	elif event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event.is_action_pressed("shoot"):
		_shoot()
	elif event.is_action_released("boost"):
		_lowered_gravity = false
		_spring._spring_constant = 50.0
#		if event.is_pressed():
#			_spring._spring_constant = 500.0
#		else:
#			_spring._spring_constant = 200.0

func _process(_delta):
	$AmmoCounter.ammo = _bullets

func _physics_process(delta: float):
	var horizontal: float = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
	rotation_degrees += horizontal * delta * 270.0
#	update()
	# forces

#	if _gravity_nudge <= delta:
#		_gravity_nudge = 0.0
#	_gravity_nudge += -sign(_gravity_nudge) * delta
	# gravity
#	_velocity += Vector2(0, _gravity + _gravity_nudge) * delta # gravity
	var effective_gravity: float = _gravity
	if _lowered_gravity:
		effective_gravity = _lowered_jump_gravity
	_velocity += Vector2(0, effective_gravity) * delta # gravity
	
	# spring force
	if _spring.is_colliding() and Input.is_action_pressed("boost"):
		_lowered_gravity = true
		_spring._spring_constant = 300.0
		
	if _spring.is_colliding() and (_spring.get_collision_point() - _spring.global_position).normalized().dot(_velocity.normalized()) < 0.0:
		_bullets = 3
		$Spring/ColorRect.color = Color(1, 0, 0)
	else:
		$Spring/ColorRect.color = Color(1, 1, 1)
	var spring_rotation: float = _spring.global_rotation + PI/2.0
	_velocity += Vector2(_spring.get_spring_force(), 0).rotated(spring_rotation) * delta
	
	
	# bounce on collision
#	_velocity = move_and_slide(_velocity, Vector2(0, -1))
	var collision: KinematicCollision2D = move_and_collide(_velocity * delta)
	if collision != null:
		_velocity = -_velocity.reflect(collision.normal)*0.5

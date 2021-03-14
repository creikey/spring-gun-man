extends RayCast2D

export var _spring_constant: float = 50.0

onready var _max_spring_length: float = cast_to.y

func _get_spring_length() -> float:
	if not is_colliding():
		return _max_spring_length
	return get_collision_point().distance_to(global_position)

func get_spring_force() -> float:
	if not is_colliding():
		return 0.0
	return -_spring_constant * (_max_spring_length - _get_spring_length())

func _process(delta):
	$ColorRect.rect_size.y = _get_spring_length()

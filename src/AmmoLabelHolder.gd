extends Node2D

var ammo: int = 3 setget set_ammo

onready var _ammo_label: Label = $CenterContainer/AmmoLabel

func set_ammo(new_ammo: int):
	ammo = new_ammo
	if _ammo_label != null:
		_ammo_label.text = str(ammo)

func _process(_delta):
	global_rotation = 0.0

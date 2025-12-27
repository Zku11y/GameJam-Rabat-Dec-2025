extends Node3D

@export var max_blood: int = 100
var blood: int

signal blood_changed(current, max)
signal died

func _ready():
	blood = max_blood

func set_max_blood(value: int):
	max_blood = value
	blood = min(blood, max_blood)
	emit_signal("blood_changed", blood, max_blood)

func take_damage(dmg: int):
	blood -= dmg
	blood = max(blood, 0)
	emit_signal("blood_changed", blood, max_blood)

	if blood == 0:
		emit_signal("died")

func heal(amount: int):
	blood += amount
	blood = min(blood, max_blood)
	emit_signal("blood_changed", blood, max_blood)

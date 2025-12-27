extends Node3D

@onready var _anim = $AnimationPlayer
var projectile = "res://projectile.tscn"

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		if !_anim.is_playing():
			_anim.play("shoot")
			var instance = projectile.instantiate()
			instance.position = global_position
			instance.transform.basis = global_transform.basis
			add_child(instance)

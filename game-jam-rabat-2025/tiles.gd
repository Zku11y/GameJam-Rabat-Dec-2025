extends Node3D

@onready var anim = $AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "CharacterBody3D":
		anim.play("tile 1")
		anim.play("tile 2")
		anim.play("tile 3")
		anim.play("tile 4")
		anim.play("tile 5")
		anim.play("tile 6")

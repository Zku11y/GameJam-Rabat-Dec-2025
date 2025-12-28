extends Area3D

@export var time : Timer

func _on_body_entered(body: Node3D) -> void:
	if body.name == "CharacterBody3D":
		get_tree().reload_current_scene()

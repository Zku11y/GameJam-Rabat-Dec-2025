extends CSGBox3D

@onready var anime = $AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	anime.play("trap_2")
	

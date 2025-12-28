extends CSGBox3D

@onready var anime = $AnimationPlayer
var animation_played = false
func _on_area_3d_body_entered(body: Node3D) -> void:
		#print("print_entered ", body.name)
	if body.name == "CharacterBody3D":
		if animation_played == false:
			anime.play("rotate")
		animation_played = true

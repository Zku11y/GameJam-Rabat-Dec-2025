extends CSGBox3D

@onready var anim = $AnimationPlayer
var opened = false

func _on_area_3d_body_entered(body: Node3D):
	print("play %d", body.name)
	anim.play("open")
	opened = true
	

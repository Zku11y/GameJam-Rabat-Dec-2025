extends Node3D

@export var DMG = 10

@onready var anim = $AnimationPlayer

var can_hit = true
var is_attacking = false

var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack")  and can_hit:
		is_attacking = true
		anim.play("attack")
		can_hit = false
		if not enemies.is_empty():
			for i in enemies:
				i._take_dmg(DMG)


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.has_method("_take_dmg") and not enemies.has(body):
		enemies.append(body)
		if  is_attacking:
			body._take_dmg(DMG)


func _on_hitbox_body_exited(body: Node3D) -> void:
	if enemies.has(body):
		enemies.erase(body)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	can_hit = true
	is_attacking = false

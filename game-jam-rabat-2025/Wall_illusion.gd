extends CSGBox3D

@export var max_push := 0.9
@export var trigger_distance := 2.0
@export var push_speed := 6.0

@export_enum("auto", "x", "y", "z") var axis := "auto"

var original_transform: Transform3D
var push_amount := 0.0
var disabled := false   # ← set to true when hidden button is pressed

func _ready():
	original_transform = global_transform
	add_to_group("illusion_walls")

func _physics_process(delta):
	if disabled:
		return

	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var dist := global_position.distance_to(player.global_position)
	var target_push := 0.0

	if dist < trigger_distance:
		target_push = max_push * (1.0 - dist / trigger_distance)

	push_amount = lerp(push_amount, target_push, delta * push_speed)
	_apply_push()

func _apply_push():
	var dir := _get_push_direction()
	global_transform.origin = original_transform.origin + dir * push_amount

# 🔒 Call this ONCE from the hidden button
func disable_forever():
	disabled = true
	push_amount = 0.0
	global_transform = original_transform

func _get_push_direction() -> Vector3:
	if axis == "x":
		return original_transform.basis.x
	if axis == "y":
		return Vector3.UP
	if axis == "z":
		return -original_transform.basis.z
	return -original_transform.basis.z

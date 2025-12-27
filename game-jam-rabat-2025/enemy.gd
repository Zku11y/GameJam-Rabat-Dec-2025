extends CharacterBody3D

@export var HP = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _take_dmg(amount: int):
	HP -= amount
	if HP < 0:
		HP = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print("enemy HP: ", HP)
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

	

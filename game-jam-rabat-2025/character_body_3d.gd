extends CharacterBody3D

const WALK_SPEED = 1.0
const RUN_SPEED = 3.0
var SPEED = 2.0
const JUMP_VELOCITY = 3.0
const SENSITIVITY = 0.007

@onready var head : Node3D = $Node3D
@onready var camera = $Node3D/Camera3D

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-45), deg_to_rad(45))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("run") and is_on_floor():
		SPEED = RUN_SPEED
		camera.fov = lerp(camera.fov, 120.0, delta * 5.0)
	else:
		SPEED = WALK_SPEED
		camera.fov = lerp(camera.fov, 70.0, delta * 5.0)
	
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			camera.rotation.z = lerp(camera.rotation.z, -input_dir.x * 0.1, delta * 5.0)
		else:
			#velocity.x = lerp(velocity.x, 0, 0.2)
			#velocity.z = lerp(velocity.z, 0, 0.2)
			velocity.x = move_toward(velocity.x, 0, SPEED * delta * 2.0)
			velocity.z = move_toward(velocity.z, 0, SPEED * delta * 2.0)
			camera.rotation.z = lerp(camera.rotation.z, 0.0, delta * 5.0)
		if Input.is_action_just_pressed("dash"):
			velocity.x += direction.x * 100
			velocity.z += direction.z * 100
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 1.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 1.0)
		
		

	move_and_slide()

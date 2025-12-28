extends CharacterBody3D

# ===== SPEED =====
const WALK_SPEED := 5.0
const RUN_SPEED := 10.0
const AIR_CONTROL := 6.0

# ===== JUMP / WALL JUMP =====
const JUMP_VELOCITY := 8.0
const WALL_JUMP_FORCE := 10.0
const WALL_JUMP_UP := 8.0

# ===== DASH =====
const DASH_SPEED := 18.0
const DASH_TIME := 0.15

# ===== MOUSE =====
const SENSITIVITY := 0.007

@onready var head: Node3D = $Node3D
@onready var camera: Camera3D = $Node3D/Camera3D

var hand_node = head

var speed := WALK_SPEED
var dash_timer := 0.0
var dash_dir := Vector3.ZERO
var dash_down := false
var dash_side := false

var died := false
var ghost := false
var teto := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta):
	# ===== DEATH BY FALL =====
	if position.y < -50.0 and not died:
		die()
	print(teto)
	# ===== RESET POSITION IF DIED =====
	if died:
		position = Vector3.ZERO
		died = false

	# ===== GHOST INPUT =====
	if Input.is_action_just_pressed("ghost") and not ghost:
		if teto > 0:
			start_ghost()
		else:
			die()

	# ===== GRAVITY =====
	if not is_on_floor() and not dash_down:
		velocity += get_gravity() * delta
	velocity.y = max(velocity.y, -40.0)

	# ===== JUMP / WALL JUMP =====
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall():
			var wall_normal := get_wall_normal()
			velocity.x = wall_normal.x * WALL_JUMP_FORCE
			velocity.z = wall_normal.z * WALL_JUMP_FORCE
			velocity.y = WALL_JUMP_UP
			reset_dash()

	# ===== RUN =====
	speed = RUN_SPEED if Input.is_action_pressed("run") else WALK_SPEED
	camera.fov = lerp(camera.fov, 95.0 if speed == RUN_SPEED else 75.0, delta * 6)

	# ===== MOVEMENT =====
	var input := Input.get_vector("left", "right", "forward", "backward")
	var dir := (head.basis * Vector3(input.x, 0, input.y)).normalized()

	if not dash_side and not dash_down:
		if is_on_floor():
			velocity.x = dir.x * speed
			velocity.z = dir.z * speed
		else:
			velocity.x = move_toward(velocity.x, dir.x * speed, AIR_CONTROL)
			velocity.z = move_toward(velocity.z, dir.z * speed, AIR_CONTROL)

	# ===== DASH INPUT (Wall-aware) =====
	if Input.is_action_just_pressed("dash_left"):
		if not (is_on_wall() and get_wall_normal().x > 0):
			start_dash(-head.basis.x, true, false)

	if Input.is_action_just_pressed("dash_right"):
		if not (is_on_wall() and get_wall_normal().x < 0):
			start_dash(head.basis.x, true, false)

	if Input.is_action_just_pressed("dash_down") and not is_on_floor():
		start_dash(Vector3.DOWN, false, true)

	# ===== DASH UPDATE =====
	if dash_timer > 0.0:
		dash_timer -= delta
		var dash_motion = dash_dir * DASH_SPEED * delta
		if dash_down:
			dash_motion = Vector3(0, -DASH_SPEED * delta, 0)

		# Move with collision for safety
		move_and_collide(dash_motion)
	else:
		reset_dash()

	move_and_slide()

# ===== DEATH FUNCTION =====
func die():
	if teto < 67:
		teto += 1
	died = true

# ===== GHOST FUNCTION =====
func start_ghost():
	ghost = true
	teto -= 1
	# Wait 5 seconds asynchronously
	await get_tree().create_timer(5.0).timeout
	ghost = false

# ===== DASH FUNCTION =====
func start_dash(dir: Vector3, side: bool, down: bool):
	dash_dir = dir.normalized()
	dash_timer = DASH_TIME
	camera.fov += 10
	dash_down = down
	dash_side = side

# ===== RESET DASH =====
func reset_dash():
	dash_down = false
	dash_side = false
	dash_timer = 0.0

extends CharacterBody3D
class_name Player

const SPEED = 3.5
const JUMP_VELOCITY = 3.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction: Vector3

@onready var camera: ThirdPersonCamera = $ThirdPersonCamera
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.mouse_follow = true

func _physics_process(delta: float) -> void:
	_process_movements(delta)

func _process(delta: float) -> void:
	_process_animation(delta)

func _input(event):
	## make mouse disapear/appear and camera follow/not the mouse
	if event.is_action_pressed("ui_cancel"):
		camera.mouse_follow = Input.mouse_mode != Input.MOUSE_MODE_CAPTURED
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if camera.mouse_follow else Input.MOUSE_MODE_VISIBLE

func _process_movements(delta: float) -> void:
	if not is_on_floor(): velocity.y -= gravity * delta

	direction = Vector3.ZERO
	var aim = global_transform.basis
	var move_speed = 0

	if Input.is_action_pressed("front"):
		direction += aim.z
		move_speed = SPEED
	if Input.is_action_pressed("back"):
		direction += -aim.z
		move_speed = SPEED/2
	if Input.is_action_pressed("left"): rotation_degrees.y += 2
	if Input.is_action_pressed("right"): rotation_degrees.y -= 2

	if direction:
		velocity = Vector3(1, 0, 1) * direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

func _process_animation(_delta: float) -> void:
	var dir := int(Input.is_action_pressed("front")) - int(Input.is_action_pressed("back"))
	animation_tree.set("parameters/blend_position", dir)

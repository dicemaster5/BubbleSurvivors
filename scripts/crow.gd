extends Node3D

@onready var regular: Node3D = $regular
@onready var flying: Node3D = $flying
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var idle_timer: Timer = $IdleTimer
@onready var move_timer: Timer = $MoveTimer
@onready var flight_timer: Timer = $FlightTimer

@export var spook_radius: float
@export var flight_speed: float
@export var move_speed: float

var is_flying = false

var is_moving = false
var move_direction: Vector3

func _ready() -> void:
	collision_shape_3d.scale = Vector3(spook_radius, spook_radius, spook_radius)

func _physics_process(delta: float) -> void:
	if is_flying:
		global_position += delta * flight_speed * Vector3(move_direction.x, 0.5, move_direction.z)
	if is_moving:
		global_position += delta * move_speed * move_direction

func fly() -> void:
	flight_timer.start()
	is_flying = true
	regular.visible = false
	flying.visible = true

func _on_area_3d_body_entered(_body: Node3D) -> void:
	print('area3d')
	fly()

func _on_flight_timer_timeout() -> void:
	queue_free()

func _on_move_timer_timeout() -> void:
	idle_timer.start()
	is_moving = false
	animation_player.play("idle")

func _on_idle_timer_timeout() -> void:
	move_timer.start()
	is_moving = true
	var rand_dir = randf_range(0, 2.0 * PI)
	move_direction = Vector3(cos(rand_dir), 0, sin(rand_dir))
	look_at(global_position + move_direction)
	animation_player.play("move")

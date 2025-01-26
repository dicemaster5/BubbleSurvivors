class_name CollectableBubble extends RigidBody3D

var is_attached: bool
var player_attachment: Player


@export var upgrade: Player.Upgrade = Player.Upgrade.None

func _ready() -> void:
	body_entered.connect(on_body_entered)

	# Random size on start
	scale = scale * randf_range(0.75, 1.25)

	var r = randf()
	if r < 0.5:
		upgrade = Player.Upgrade.None
	elif r < 0.66:
		upgrade = Player.Upgrade.FireSpread
		$BubbleMesh.material_override = load("res://materials/bubble_purple.tres")
	elif r < 0.83:
		upgrade = Player.Upgrade.FireRate
		$BubbleMesh.material_override = load("res://materials/bubble_red.tres")
	elif r < 0.99:
		upgrade = Player.Upgrade.MovementSpeed
		$BubbleMesh.material_override = load("res://materials/bubble_green.tres")
	else:
		upgrade = Player.Upgrade.MegaShotgun
		$BubbleMesh.material_override = load("res://materials/bubble_mega.tres")

func _process(_delta: float) -> void:
	pass

func on_body_entered(body: Node) -> void:
	print("Collided with ", body.name)
	if body is CollectableBubble:
		if !is_attached:
			connect_to_body(body)
	else:
		print("popped from ", body.collision_layer)
		pop_bubble()

func find_player_parent(node: Node3D) -> Node3D:
	var parent = node.get_parent()
	while parent is Node3D:
		if parent is Player:
			return parent
		parent = parent.get_parent()
	return null

func connect_to_body(body: Node3D) -> void:
	if not player_attachment:
		player_attachment = find_player_parent(body)
		if player_attachment:
			player_attachment.add_upgrade.emit(upgrade)

	print("Bubble Connected! to ", body.name)
	squish(self, Vector3(1.2, 0.6, 1.2), Vector3.ONE, 0.2)
	freeze = true
	reparent.call_deferred(body)
	is_attached = true

func pop_bubble() -> void:
	if player_attachment:
		player_attachment.remove_upgrade.emit(upgrade)
		player_attachment = null
	
	squish(self, Vector3(0.75, 1.5, 0.75), Vector3.ONE, 0.12)
	await get_tree().create_timer(0.12).timeout
	queue_free()

## Squish tween.
static func squish(node_to_squish: Node3D, squich_amount: Vector3, start_scale: Vector3, squish_duration: float = 0.5) -> void:
	var time := squish_duration / 3.0
	var tween: Tween = node_to_squish.create_tween().chain().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node_to_squish, "scale", squich_amount, time)
	tween.tween_property(node_to_squish, "scale", start_scale + (start_scale * 0.15), time)
	tween.tween_property(node_to_squish, "scale", start_scale, time)

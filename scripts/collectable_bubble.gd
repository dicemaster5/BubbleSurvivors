class_name CollectableBubble extends RigidBody3D

var player_attachment: Player

@export var upgrade: Player.Upgrade = Player.Upgrade.None
@export var bubble_vfx: PackedScene

func _ready() -> void:

	var r = randf()
	if r < 0.5:
		upgrade = Player.Upgrade.None
	elif r < 0.66:
		upgrade = Player.Upgrade.FireSpread
		$CollisionShape3D/BubbleMesh.material_override = load("res://materials/bubble_purple.tres")
	elif r < 0.83:
		upgrade = Player.Upgrade.FireRate
		$CollisionShape3D/BubbleMesh.material_override = load("res://materials/bubble_red.tres")
	elif r < 0.99:
		upgrade = Player.Upgrade.MovementSpeed
		$CollisionShape3D/BubbleMesh.material_override = load("res://materials/bubble_green.tres")
	else:
		upgrade = Player.Upgrade.MegaShotgun
		$CollisionShape3D/BubbleMesh.material_override = load("res://materials/bubble_mega.tres")
	
	$Collectable.connected.connect(on_connected)
	$Collectable.popped.connect(on_popped)

func on_connected(body: Node3D) -> void:
	if not player_attachment:
		player_attachment = find_player_parent(body)
		if player_attachment:
			player_attachment.add_upgrade.emit(upgrade)

	squish(self, Vector3(1.2, 0.6, 1.2), Vector3.ONE, 0.2)

func on_popped() -> void:
	var popvfx = bubble_vfx.instantiate()
	get_tree().current_scene.add_child(popvfx)
	popvfx.global_position = global_position

	if player_attachment:
		player_attachment.remove_upgrade.emit(upgrade)
		player_attachment = null
	
	squish(self, Vector3(0.75, 1.5, 0.75), Vector3.ONE, 0.12)

func find_player_parent(node: Node3D) -> Node3D:
	var parent = node.get_parent()
	while parent is Node3D:
		if parent is Player:
			return parent
		parent = parent.get_parent()
	return null

## Squish tween.
static func squish(node_to_squish: Node3D, squich_amount: Vector3, start_scale: Vector3, squish_duration: float = 0.5) -> void:
	var time := squish_duration / 3.0
	var tween: Tween = node_to_squish.create_tween().chain().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node_to_squish, "scale", squich_amount, time)
	tween.tween_property(node_to_squish, "scale", start_scale + (start_scale * 0.15), time)
	tween.tween_property(node_to_squish, "scale", start_scale, time)

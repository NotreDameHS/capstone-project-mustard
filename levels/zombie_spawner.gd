# This script controls spawning zombies into the main scene
# Goal: randomly spawn different types of zombies inside allowed spawn zones

class_name ZombieSpawner
extends Node2D

# Stores the different zombie scenes that can be spawned
@export var zombie_scenes: Array[PackedScene] = []

# Maximum zombies allowed at once so the game does not get too chaotic
@export var max_zombies: int = 8

# How far away from the player zombies should avoid spawning
@export var min_spawn_distance_from_player: float = 250.0

# This points to the SpawnZones node in the main scene
@export var spawn_zones_path: NodePath

# Reference to the player
var player: Node2D = null

# Stores the spawn zone nodes
var spawn_zones: Array[Node] = []

@onready var spawn_timer = $SpawnTimer


func _ready() -> void:
	# Find player using the Player group
	player = get_tree().get_first_node_in_group("Player")
	
	# Find the SpawnZones node
	var spawn_zones_parent = get_node_or_null(spawn_zones_path)
	
	if spawn_zones_parent != null:
		spawn_zones = spawn_zones_parent.get_children()
	else:
		print("No SpawnZones node selected")
	
	# Connect timer so zombies keep spawning
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	# Start spawning zombies
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	spawn_zombie()


func spawn_zombie() -> void:
	# Check how many zombies currently exist
	var current_zombies = get_tree().get_nodes_in_group("Enemy")
	
	# If there are already too many zombies, stop and don't spawn more
	if current_zombies.size() >= max_zombies:
		return
	
	if player == null:
		return
	
	if zombie_scenes.size() == 0:
		print("No zombie scenes added to spawner")
		return
	
	if spawn_zones.size() == 0:
		print("No spawn zones found")
		return
	
	# Pick a random zombie scene
	var random_index = randi_range(0, zombie_scenes.size() - 1)
	var zombie = zombie_scenes[random_index].instantiate()
	
	# Pick a spawn position inside one of the allowed spawn zones
	var spawn_position = get_random_spawn_position()
	
	zombie.global_position = spawn_position
	
	# Add zombie to the current scene
	get_tree().current_scene.add_child(zombie)


func get_random_spawn_position() -> Vector2:
	var spawn_position = Vector2.ZERO
	
	# Try a few times to find a position not too close to the player
	for i in 20:
		var zone = spawn_zones.pick_random()
		var collision_shape = zone.get_node_or_null("CollisionShape2D")
		
		if collision_shape == null:
			continue
		
		if collision_shape.shape is RectangleShape2D:
			var rect_shape = collision_shape.shape as RectangleShape2D
			
			var size = rect_shape.size
			var center = collision_shape.global_position
			
			var left = center.x - size.x / 2
			var right = center.x + size.x / 2
			var top = center.y - size.y / 2
			var bottom = center.y + size.y / 2
			
			spawn_position = Vector2(
				randf_range(left, right),
				randf_range(top, bottom)
			)
			
			# Make sure zombies do not spawn directly on top of the player
			if spawn_position.distance_to(player.global_position) >= min_spawn_distance_from_player:
				return spawn_position
	
	# If it cannot find a perfect spot, just return the last position it tried
	return spawn_position

# This script controls spawning zombies into the main scene
# Goal: randomly spawn different types of zombies over time

class_name ZombieSpawner
extends Node2D

# Stores the different zombie scenes that can be spawned
@export var zombie_scenes: Array[PackedScene] = []

# How far away from the player zombies should spawn
@export var spawn_distance: float = 500.0

# Maximum zombies allowed at once so the game does not get too chaotic
@export var max_zombies: int = 8

# Reference to the player so zombies can spawn around them
var player: Node2D = null

@onready var spawn_timer = $SpawnTimer


func _ready() -> void:
	# Find player using the Player group
	player = get_tree().get_first_node_in_group("Player")
	
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
	
	# Pick a random zombie scene
	var random_index = randi_range(0, zombie_scenes.size() - 1)
	var zombie = zombie_scenes[random_index].instantiate()
	
	# Pick a random direction around the player
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	# Spawn zombie away from the player
	zombie.global_position = player.global_position + random_direction * spawn_distance
	
	# Add zombie to the current scene
	get_tree().current_scene.add_child(zombie)

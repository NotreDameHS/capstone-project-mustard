# This enemy scene acts as the base enemy class
# I will have 3 different types of zombies: walker normal/OG, runner, tank like the mega bosses
class_name BaseEnemy
extends CharacterBody2D

# Export variables allow me to edit values directly in the Inspector without touching this base code for my inherited scenes >:)

@export var brain_sample_scene: PackedScene

# Controls zombie movement speed
@export var speed: float = 80.0

# Stores the enemy's maximum possible health
# Separating max health from current health because current health will change during the game
@export var max_health: float = 100.0

# Controls how many brain samples are dropped after zombie dies
# Having it as an export var because I'm thinking of having the other types of zombies that are harder to beat drop more brains
@export var brain_drop_amount: int = 1 # int because they aren't dropping half a brain

# Controls how much damage the zombie does to the player
@export var attack_damage: float = 10.0

# Controls how often the zombie attacks when the player is in range
@export var attack_cooldown: float = 1.0

# Reference to the sprite so only the sprite flips, not the whole zombie scene
@onready var sprite = $Sprite2D

# Reference to the enemy health bar
@onready var health_bar = $HealthBar

# Reference to the player
# Using groups instead of a hardcoded scene path because it will work in any scene
var player: Node2D = null

# This will store the enemy's current health during the game
# I'm going to use float instead of int because future upgrades or damage systems may need to use a decimal value
var health: float

# Checks if the player is close enough for the zombie to attack
var player_in_range: bool = false

# Stops the attack loop from starting a million times
var is_attacking: bool = false


func _ready() -> void:
	# I want the starting health to be the max because it should always start full
	health = max_health
	
	health_bar.min_value = 0
	# Setting the healthbar's max value because the bar needs to know the full range of values
	health_bar.max_value = max_health
	
	# Setting the health bar's current value so it appears full when enemy spawns
	health_bar.value = health
	
	# Search for the player automatically using groups
	# This allows the enemy to work in any testing scene without needing a specific scene path
	player = get_tree().get_first_node_in_group("Player")


func _physics_process(delta: float) -> void:
	# Stop the function if no player exists to prevent crashes/errors if the player dies or is missing
	if player == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Calculate direction to the player and move
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	
	# Flip sprite depending on movement direction
	# This keeps the health bar upright because we are not rotating the whole enemy
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
	
	# Applying movement to the enemy
	move_and_slide()


func take_damage(amount: float) -> void:
# Debug message to prove damage is being received
	print("take_damage was called on zombie with amount: ", amount)
	
	# Reducing enemy's health by the incoming damage amount
	health -= amount
	
	# Making sure health cannot go below 0 or above max health
	health = clamp(health, 0, max_health)
	
	# Update health bar visually so that the healthbar decreases when enemy is hit
	health_bar.value = health
	
	# Debug message so I can confirm the enemy is taking damage
	print("Zombie health is now: ", health)
	print("Zombie health bar value is now: ", health_bar.value)
	
	# If health reaches zero or below kill the enemy
	if health <= 0:
		die()

func die() -> void:
	# Debug message just to confirm my logic isn't broken
	print("Zombie died")
	
	# Drop brain samples when zombie dies
	for x in brain_drop_amount:
		if brain_sample_scene != null:
			var brain_sample = brain_sample_scene.instantiate()
			brain_sample.global_position = global_position
			get_tree().current_scene.add_child(brain_sample)
	
	# Removing enemy from the scene
	queue_free()


func _on_attack_range_body_entered(body: Node2D) -> void:
	# If the player enters the zombie's attack range, start attacking
	if body.is_in_group("Player"):
		player_in_range = true
		player = body
		attack_player()


func _on_attack_range_body_exited(body: Node2D) -> void:
	# If the player leaves attack range, stop attacking
	if body.is_in_group("Player"):
		player_in_range = false


func attack_player() -> void:
	# This prevents multiple attack loops from running at the same time
	if is_attacking:
		return
	
	is_attacking = true
	
	# While the player is in range, attack every few seconds
	while player_in_range and player != null:
		print("Zombie attacking player!")
		
		# Only damage the player if the player has a take_damage function
		if player.has_method("take_damage"):
			player.take_damage(attack_damage)
		
		await get_tree().create_timer(attack_cooldown).timeout
	
	is_attacking = false


func _on_detection_area_body_entered(body) -> void:
	if body.is_in_group("Player"): # Best practice: Use groups instead of hardcoded names
		player = body


func _on_detection_area_body_exited(body) -> void:
	if body == player:
		player = null # Stop chasing if the player runs away
		velocity = Vector2.ZERO

# This enemy scene acts as the base enemy class
# I will have 3 differnt types of zombies (walker (normal/OG), runner, tank (like the mega bosses)

class_name BaseEnemy extends CharacterBody2D

# Export variables allow me to edit values directly in the Inspector without touching this base code for my inherited scenes >:)

# Controls zombie movement speed
@export var speed: float = 80.0
# Stores the enemy's maximum possible health
# Seperating max health from current health because current health will change during the game
@export var max_health: float = 100.0
# Controls how many brain samples are dropped after zombie dies
# Having it as an export var because I'm thinking of having the other types of zombies that are harder to beat drop more brains
@export var brain_drop_amount: int = 1 # int because they aren't dropping haf a brain (it could change but that will just be confusing)


@onready var player = $/root/Main/Player
# This will store the enemy's current health durrent the game
# I'm going to use float instead of int because future upgrades or damage systems may need to use a decimal value (we never know so better safe)
var health: float

func _ready() -> void:
	# I want the starting health to be the max because it should always start at 100 
	health = max_health
	
	# Setting the healthbar's max value because the bar needs to know the full range of values
	# Making sure the bar will appear full when enemy spawns
	$HealthBar.max_value = max_health
	
	# Setting the health bar's current value so it appears full when enemy spawns.
	$HealthBar.value = health

func _physics_process(delta: float) -> void:

	# Search the scene tree for the player using groups
	# Groups are cleaner than manually assigning references
	# Every enemy can easily find the player automatically
	if player:
		# Calculate direction to the player and move
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		
		# Optional: Make the enemy look at the player
		look_at(player.global_position)
		
		move_and_slide()
	
	# Stop the function if no player exists to prevent crashes/errors if the player dies or is missing from the scene :')
	#if player == null:
	#	return
	
	# Creating a direction vector pointing toward the player 
	# Subtracting positions gives me the direction from the zombie to the player. We are #tryingtomakethiseasierforlater
	#var direction = (player.global_position - global_position).normalized()
	
	# Multiplying direction by speed so I can create movement velocity so normalized() keeps movement speed consistent in all directions
	# Trying to get the zombies to smoothly chase the player
	#velocity = direction * speed
	
	# Applying movement to the enemy
	# move_and_slide()

func take_damage(amount: float) -> void:
	# Reducing enemies health by the incoming damage amount
	health -= amount
	
	# Update health bar visually so that the healthbar decreases when enemy is hit
	$HealthBar.value = health
	
	# If health reaches zero or below kill the enemy
	# Making sure enemy removed once killed off
	if health <= 0:
		die()

func die() -> void:
	# Debug message just to confirm my logic isn't shit
	print("Zombie died")
	
	# Removing enemy from the scene. Zombie – in theory – should disappear after dying (please)
	queue_free()

var player_in_range = false

func _on_attack_range_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		attack_player()

func _on_attack_range_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func attack_player():
	while player_in_range:
		# Add your damage logic here, e.g., player.take_damage(10)
		print("Attacking player!")
		await get_tree().create_timer(1.0).timeout # Attack every 1 second


func _on_detection_area_body_entered(body) -> void:
	if body.is_in_group("Player"): # Best practice: Use groups instead of hardcoded names
		player = body


func _on_detection_area_body_exited(body) -> void:
	if body == player:
		player = null # Stop chasing if the player runs away
		velocity = Vector2.ZERO

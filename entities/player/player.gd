# The player character for the game
# Goal: have this scene handle movements that will later handle weapons, health, upgrades, and collection of brain samples
class_name Player
extends CharacterBody2D

# Having it as an export will help me have an easier time tweaking this later on – specially because I plan on having a speed upgrade
@export var max_speed: float = 5.0

# Stores the player's maximum health
@export var max_health: float = 100.0

# This will store the player's current health during the game
var health: float


func _ready() -> void:
	print("READY")
	
	# Starting health should always begin at max health
	health = max_health


func _physics_process(delta: float) -> void:
	# This specifically stores movement direction. Will start at zero until player presses a move key
	var direction = Vector2.ZERO
	
	# In our spaceship project we used Input.get_axis() because it automatically handles everything
	# Way cleaner than if it were to be done manually
	
	# WASD keys connected to each move_ movement – help from previous lessons
	
	# Checking horizontal movement input
	direction.x = Input.get_axis("move_left", "move_right")
	
	# Checking for up and down movement
	direction.y = Input.get_axis("move_up", "move_down")
	
	# Using logic from previous spaceman project
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	velocity = direction * max_speed
	
	# MOVING PLAYER
	position.x += velocity.x
	position.y += velocity.y
	
	# Flipping sprite depending on which direction the player is moving
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
	
	# Applying movement
	# move_and_slide()


func take_damage(amount: float) -> void:
	# Reducing the player's health by the incoming enemy damage amount
	health -= amount
	
	# Debug message so I can confirm the player is actually taking damage
	print("Player took damage. Health is now: ", health)
	
	# If health reaches zero or below, the player dies
	if health <= 0:
		die()


func die() -> void:
	# Debug message to confirm death logic works
	print("Player died")
	
	# Removing player from the scene for now
	queue_free()

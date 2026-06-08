# The player character for the game
# Goal: have this scene handle movements that will later handle weapons, health, upgrades, and collection of brain samples
class_name Player
extends CharacterBody2D

@onready var health_bar = $HealthBar

# Having it as an export will help me have an easier time tweaking this later on – specially because I plan on having a speed upgrade
@export var max_speed: float = 5.0

# Stores the player's maximum health
@export var max_health: float = 100.0

# This will store the player's current health during the game
var health: float

var facing_direction: Vector2 = Vector2.RIGHT

var brain_samples: int = 0

var brain_goal: int = 50

func _ready() -> void:
	print("READY")
	
	health = max_health
	
	health_bar.min_value = 0
	# Starting health should always begin at max health
	health_bar.max_value = max_health
	health_bar.value = health



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
	#if velocity.x > 0:
	#	$Sprite2D.flip_h = false
	#elif velocity.x < 0:
#		$Sprite2D.flip_h = true

	# trying to get the weapon to move with the player
	#if velocity.x > 0:
	#	$WeaponHolder.scale.x = 1
	#elif velocity.x < 0:
	#	$WeaponHolder.scale.x = -1
	
	# Replacing the old:
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
		$WeaponHolder.scale.x = 1
		facing_direction = Vector2.RIGHT

	elif velocity.x < 0:
		$Sprite2D.flip_h = true
		$WeaponHolder.scale.x = -1
		facing_direction = Vector2.LEFT

func take_damage(amount: float) -> void:
	# Reducing the player's health by the incoming enemy damage amount
	health -= amount
	health = clamp(health, 0, max_health)
	
	health_bar.value = health
	
	# Debug message so I can confirm the player is actually taking damage
	print("Player took damage. Health is now: ", health)
	print("Player health bar value is now: ", health_bar.value)
	
	# If health reaches zero or below, the player dies
	if health <= 0:
		die()


func die() -> void:
	# Debug message to confirm death logic works
	print("Player died")
	
	# Removing player from the scene for now
	queue_free()


func collect_brain_sample(amount: int) -> void:
	brain_samples += amount
	
	print("Brain samples: ", brain_samples, "/", brain_goal)
	
	if brain_samples >= brain_goal:
		print("YOU WIN / GAME OVER")

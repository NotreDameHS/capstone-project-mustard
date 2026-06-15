# The player character for the game
# Goal: have this scene handle movement, weapons, health, upgrades, and collection of brain samples

class_name Player
extends CharacterBody2D

# Having it as an export will help me have an easier time tweaking this later on – especially because I plan on having a speed upgrade
@export var max_speed: float = 5.0

# Stores the player's maximum health
@export var max_health: float = 100.0

# How many brain samples the player needs to win the game
@export var brain_goal: int = 50

# Reference to the player's health bar
@onready var health_bar = $HealthBar

# Stores the player's current health during the game
var health: float

# Stores how many brain samples the player has collected
var brain_samples: int = 0

# Stores which direction the player is facing so the weapon knows where to shoot
var facing_direction: Vector2 = Vector2.RIGHT

# UI references
var brain_label: Label = null
var health_label: Label = null
var game_over_label: Label = null
var win_label: Label = null


func _ready() -> void:
	print("READY")
	
	# Starting health should always begin at max health
	health = max_health
	
	# Setting up the player's health bar
	health_bar.min_value = 0
	health_bar.max_value = max_health
	health_bar.value = health
	
	# Finding UI labels from the main scene
	brain_label = get_tree().current_scene.get_node("CanvasLayer/BrainLabel")
	health_label = get_tree().current_scene.get_node("CanvasLayer/HealthLabel")
	game_over_label = get_tree().current_scene.get_node("CanvasLayer/GameOverLabel")
	win_label = get_tree().current_scene.get_node("CanvasLayer/WinLabel")
	
	# Make sure game over and win text are hidden at the start
	if game_over_label != null:
		game_over_label.visible = false
	
	if win_label != null:
		win_label.visible = false
	
	# Update UI when the game starts
	update_brain_label()
	update_health_label()


func _physics_process(delta: float) -> void:
	# This specifically stores movement direction. Will start at zero until player presses a move key
	var direction = Vector2.ZERO
	
	# Checking horizontal movement input
	direction.x = Input.get_axis("move_left", "move_right")
	
	# Checking vertical movement input
	direction.y = Input.get_axis("move_up", "move_down")
	
	# Normalizing direction so diagonal movement is not faster
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	velocity = direction * max_speed
	
	# Moving player
	position.x += velocity.x
	position.y += velocity.y
	
	# Flipping sprite and weapon depending on movement direction
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
	
	# Making sure health does not go below 0 or above max health
	health = clamp(health, 0, max_health)
	
	# Updating the player's health bar
	health_bar.value = health
	
	# Updating the health label
	update_health_label()
	
	# Debug message so I can confirm the player is actually taking damage
	print("Player took damage. Health is now: ", health)
	print("Player health bar value is now: ", health_bar.value)
	
	# If health reaches zero or below, the player dies
	if health <= 0:
		die()


func die() -> void:
	# Debug message to confirm death logic works
	print("Player died")
	
	# Show game over label
	if game_over_label != null:
		game_over_label.visible = true
	
	# Pause the game when player dies
	get_tree().paused = true


func collect_brain_sample(amount: int) -> void:
	# Add collected brain samples to the player's total
	brain_samples += amount
	
	# Debug message to check if collecting is working
	print("Brain samples: ", brain_samples, "/", brain_goal)
	
	# Update the brain counter UI
	update_brain_label()
	
	# Check if the player has enough brains to win
	if brain_samples >= brain_goal:
		win_game()


func update_brain_label() -> void:
	# Updates the brain counter text on screen
	if brain_label != null:
		brain_label.text = "Brains: " + str(brain_samples) + " / " + str(brain_goal)


func update_health_label() -> void:
	# Updates the health text on screen
	if health_label != null:
		health_label.text = "Health: " + str(health) + " / " + str(max_health)


func win_game() -> void:
	# Debug message to confirm win logic works
	print("YOU WIN")
	
	# Show win label
	if win_label != null:
		win_label.visible = true
	
	# Pause the game when player wins
	get_tree().paused = true

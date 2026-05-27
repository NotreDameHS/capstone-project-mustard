# The player character for the game
# Goal: have this scene handle movements that will later handle weapons, health, upgrades, and collection of brain samples
class_name Player extends CharacterBody2D

# Having it as an export will help me have an easier time tweaking this later on – specially becasue i plan on having a speed upgrade
@export var max_speed: float = 5.0


func _ready() -> void:
	print("READY")

func _physics_process(delta: float) -> void:
	# This specifically stores movement direction. Will start at zero untill player presses a move key
	var direction = Vector2.ZERO
	
	
	# In our spaceship project we used Input.get_axis() because it automatically handles everything
	# Way cleaner than if it were to be done manually
	
	# WASD keys conected to each move_ movement – help from previous leassons
	
	#Checking horizontal movement input
	direction.x = Input.get_axis("move_left", "move_right")
	
	# Cheking for up and down movement
	direction.y = Input.get_axis("move_up", "move_down")
	
	
	# Using logic from previos spaceman project
	
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	velocity = direction * max_speed
	
	
	# MOVING PLAYER
	position.x += velocity.x
	position.y += velocity.y
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
	
	# Applying movement 
	#move_and_slide()
	
	

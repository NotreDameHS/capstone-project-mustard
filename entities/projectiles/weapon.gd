# This script controls the player's weapon
# Goal: have the weapon spawn bullets from the fire point

class_name Weapon
extends Node2D

# This stores the bullet scene so the weapon knows what to spawn
@export var projectile_scene: PackedScene

# This controls how often the weapon can shoot
@export var attack_cooldown: float = 0.5

# Getting the fire point marker because this is where bullets should spawn from
@onready var fire_point = $FirePoint

# Getting the cooldown timer so the weapon does not shoot nonstop
@onready var cooldown_timer = $CooldownTimer

# Checking to see if weapon can attack
var can_attack: bool = true


func _ready() -> void:
	# Connect cooldown timer to reset attack
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)


func _process(delta: float) -> void:
	# When the player presses attack, shoot
	if Input.is_action_just_pressed("attack"):
		attack()


func attack() -> void:
	if can_attack == false:
		return
	
	if projectile_scene == null:
		print("No projectile scene selected.")
		return
	
	can_attack = false
	
	var projectile = projectile_scene.instantiate()
	
	projectile.global_position = fire_point.global_position
	
	# Telling bullet what direction the player is facing
	projectile.direction = owner.facing_direction
	
	print(projectile.direction)
	
	get_tree().current_scene.add_child(projectile)
	
	cooldown_timer.start(attack_cooldown)


func _on_cooldown_timer_timeout() -> void:
	can_attack = true

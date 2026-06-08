# Base projectile scene for all the gun bullets
# Will be inherited later for my bullets for my guns

class_name BaseProjectile
extends Area2D

@export var speed: float = 2000.0
@export var damage: float = 25.0

# This controls how long the bullet stays alive before deleting itself
# Higher number means the bullet travels farther
@export var lifetime: float = 2.0

# I'm separating direction from speed because the direction is for where the projectile moves
# where the speed is for how fast the projectile moves
var direction := Vector2.ZERO


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)
	
	# Deletes bullet after some time so it does not exist forever
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _process(delta: float) -> void:
	pass

# Testing to see if this will fix my bullet issue
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	print("Bullet hit: ", body.name)

	# If the bullet hits the player, ignore it
	if body.is_in_group("Player"):
		return

	# Checking to see if the object hit the enemy because only the zombies should take hit damage
	if body.is_in_group("Enemy"):
		
		print("Bullet hit enemy!")
		
		# Applying damage to the enemy
		if body.has_method("take_damage"):
			body.take_damage(damage)
		
		# Deleting the projectile after it has hit the enemy
		queue_free()


func _on_screen_exited() -> void:
	# Deletes the projectile once it goes off screen
	queue_free()

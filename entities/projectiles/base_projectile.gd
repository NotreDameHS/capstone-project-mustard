# Base projectile scene for all the gun bullets
# Will be inherited later for my bullets for my guns

class_name BaseProjectile extends Area2D

@export var speed: float = 600.0
@export var damage: float = 25.0


# I'm seperating direction from speed because the direction is for where the projectile moves where the speed is for how fasr the projectile moves
var direction := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Connecting Area2D collision signal so that the projectile will (hopefully) react when it touches something
	body_entered.connect(_on_body_entered)
	
	# Connecting the screen exit signal so that hpefully the projectile will be deleted once it leave sthe screen
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_existed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Moving the projectile every frame so that the projectile will move continously in it's direction
	position += direction * speed * delta
 
func _on_body_entered(body: Node2D) -> void:
	
	# Checking to see if the object hit the enemy because only the zombies should take hit damage 
	if body is BaseEnemy:
		
		# Applying damage to the enemy
		body.take_damage(damage)
		
		# Deleting the projectile after it has hit the enemy
		queue_free()

func _on_screen_existed() -> void:
	
	# Deletes the projectile once it goes off screen so there isn't a build up of invisible projectiles
	queue_free()

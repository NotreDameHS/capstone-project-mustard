class_name Weapon extends Node2D

#stores the bullet scene so the weapon knows were to spawn
@export var projectile_scene: PackedScene
#controls how often the weapos can shoot
@export var attack_cooldown: float = 0.5

#where buleets should spawn from
@onready var fire_point = $Firepoint
# cooldown so bullets dont shoot non-stop
@onready var cooldown_timer = $CooldownTimer

#checking to see if u can attack
var can_attack: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()


func attack() -> void:
	if can_attack == false:
		return
	

	if projectile_scene == null:
		print("No projectile selected.")
		return
	
	can_attack = false
	
	var projectile = projectile_scene.instantiate()
	projectile.global_position = fire_point.global_position
	
	get_tree().current_scene.add_child(projectile)
	
	cooldown_timer.start(attack_cooldown)


func _on_cooldown_timer_timeout() -> void:
	can_attack = true

class_name BrainSample extends Area2D

@export var sample_amount: int = 1 # Should always be a whole number – I don't want to drop half a brain sample

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# This – in theory – will pick up brain samples when player come in contact with it (hopefully automatically – if I didn't screw up) 
	body_entered.connect(_on_body_entered) # When something comes in contact witj Area2D, run the on body function

func _on_body_entered(body: Node2D) -> void:
	# Only want the item to be collected if it has come in contact with the player
	if body.is_in_group("Player"):
		
		# Tell the player to add this brain sample to their counter
		if body.has_method("collect_brain_sample"):
			body.collect_brain_sample(sample_amount)
		
		print("Collected brain sample: ", sample_amount)
		
		# Deleting the brain sample from the scene after the player collects it
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Delete the brain after the time given to pick it up
# I don't want to overcrowd with pickups, plus it gives some pressure on the player to pick it faster >:)
func _on_despawn_timer_timeout() -> void:
	queue_free()

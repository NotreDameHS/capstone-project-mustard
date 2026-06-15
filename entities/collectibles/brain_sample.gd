# This script controls the brain sample collectible
# Goal: when the player touches it, the player collects it and the brain counter goes up

class_name BrainSample
extends Area2D

# How many brain samples this pickup gives
@export var sample_amount: int = 1


func _ready() -> void:
	# Connecting Area2D body entered signal so that this will pick up brain samples when player touches it
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	# Only want the item to be collected if it has come in contact with the player
	if body.is_in_group("Player"):
		
		# Tell the player to add this brain sample to their counter
		if body.has_method("collect_brain_sample"):
			body.collect_brain_sample(sample_amount)
		
		print("Collected brain sample: ", sample_amount)
		
		# Deleting the brain sample from the scene after the player collects it
		queue_free()


func _on_despawn_timer_timeout() -> void:
	# Deletes the brain after a certain amount of time
	queue_free()

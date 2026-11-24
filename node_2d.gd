extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_jumpboostupgrade_body_entered(body: Node2D) -> void:
	if body.has_method("activate_jump_boost"):
		body.activate_jump_boost()
		$jumpboostupgrade.queue_free()


func _on_spike_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.death()


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.has_method("set_checkpoint"):
			body.set_checkpoint (body.global_position)

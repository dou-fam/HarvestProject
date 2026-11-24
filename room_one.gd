extends Area2D

@export var left := 0
@export var right := 1152
@export var top := 0
@export var bottom := 648

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		var cam = body.get_node("Camera2D")
		var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(cam, "limit_left", left, 0.4)
		tween.tween_property(cam, "limit_right", right, 0.4)
		tween.tween_property(cam, "limit_top", top, 0.4)
		tween.tween_property(cam, "limit_bottom", bottom, 0.4)

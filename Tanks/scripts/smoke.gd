extends AnimatedSprite

func _on_smoke_finished():
	queue_free()

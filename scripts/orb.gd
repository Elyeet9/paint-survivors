extends Area2D

# Define the direction property
var direction = Vector2.ZERO
var SPEED = 500

@onready var collision = $collisionOrb

func _process(delta):
	position += direction * SPEED * delta

	if not get_viewport_rect().has_point(position):
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.take_damage(10)
		queue_free()

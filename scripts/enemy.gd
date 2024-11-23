extends Area2D

var SPEED = 100.0
var target = null
var hp = 10

@onready var sprite = $spriteEnemy
@onready var collision = $collisionEnemy

func _ready():
	add_to_group("enemy")
	spawn_at_random_border()

func _process(delta):
	if target:
		var direction = (target.global_position - global_position).normalized()
		position += direction * SPEED * delta

func spawn_at_random_border():
	var rand_side = randi() % 4
	var spawn_position = Vector2.ZERO
	
	match rand_side:
		0: spawn_position = Vector2(randf_range(0, 800), 0)  # Top
		3: spawn_position = Vector2(0, randf_range(0, 600))  # Left
		2: spawn_position = Vector2(randf_range(0, 800), 600)  # Bottom
		1: spawn_position = Vector2(800, randf_range(0, 600))  # Right
	
	position = spawn_position

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(5)
		queue_free()
		

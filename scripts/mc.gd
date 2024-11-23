extends CharacterBody2D

const MAX_HP = 40
const SHOOT_INTERVAL = 0.8
const SPEED = 200.0

@onready var sprite = $mcSprite
@onready var health_label = get_node("../lblHealth")
@onready var orb_scene = preload("res://scenes/Orb.tscn")

var shoot_timer = 0.8
var damage_timer = 0.5
var current_hp = MAX_HP
var can_take_damage = true

func _ready():
	add_to_group("player")
	position = Vector2(400, 300)
	health_label.text = "HP: %d" % current_hp

func _process(delta):
	handle_movement()
	handle_shooting(delta)
	handle_life(delta)
	

func handle_movement():
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		
	direction = direction.normalized()
	
	velocity = direction * SPEED
	move_and_slide()
	
	position.x = clamp(position.x, 0, 800)
	position.y = clamp(position.y, 0, 600)
	
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false

func handle_shooting(delta):
	shoot_timer -= delta
	if shoot_timer <= 0:
		shoot_timer = SHOOT_INTERVAL
		shoot_orb()

func handle_life(delta):
	if not can_take_damage:
		damage_timer -= delta
		if damage_timer <= 0:
			can_take_damage = true
			damage_timer = 0.5
	
	if current_hp <= 0:
		game_over()

func shoot_orb():
	var orb = orb_scene.instantiate()
	orb.position = global_position

	var mouse_position = get_global_mouse_position()
	orb.direction = (mouse_position - global_position).normalized()

	get_tree().current_scene.add_child(orb)

func take_damage(amount):
	if can_take_damage:
		current_hp -= amount
		health_label.text = "HP: %d" % current_hp
		can_take_damage = false

func game_over():
	print("Game Over!")
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

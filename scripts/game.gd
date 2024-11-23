extends Node2D

@onready var enemy_scene = preload("res://scenes/Enemy.tscn")

var spawn_interval = 2.0
var spawn_timer = 2.0
var enemy_hp = 10

var difficulty_increase_timer = 5.0

func _process(delta):
	spawn_timer -= delta
	difficulty_increase_timer -= delta
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = spawn_interval
	if difficulty_increase_timer <= 0:
		print("Difficulty increased!")
		difficulty_increase_timer = 5.0
		enemy_hp += 1
		print("Enemy HP: " + str(enemy_hp))
		if spawn_interval > 0.5:
			spawn_interval -= 0.1
			print("Spawn Rate: " + str(spawn_interval))
			enemy_hp += 1

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.hp = enemy_hp
	enemy.target = get_node("MC")
	add_child(enemy)

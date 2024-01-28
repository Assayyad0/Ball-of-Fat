extends Node2D

@export var levels: Array[PackedScene] = [preload("res://scenes/levels/level1.tscn")]
@export var current_level: Node2D = null
@export var current_level_index = 0

@export var player: CharacterBody2D = null
@export var son: CharacterBody2D = null

func _ready():
	load_level(current_level_index)

func load_level(index):
	if current_level != null:
		current_level.queue_free()
		
	var level = levels[index]
	current_level = level.instantiate()
	add_child(current_level)
	
	var player_marker = current_level.player_pos
	var son_marker = current_level.son_pos
	
	player.set_global_position(player_marker.global_position)
	son.set_global_position(son_marker.global_position)

func next_level():
	current_level_index += 1
	if current_level_index >= levels.size():
		current_level_index = 0
	load_level(current_level_index)

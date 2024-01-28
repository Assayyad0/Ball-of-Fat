extends Node2D

@export var levels: Array[PackedScene] = [preload("res://scenes/levels/level1.tscn")]
@export var current_index = 0

var current_level: Node2D = null
var out_way: bool = false

func _ready():
	_load_level(current_index)

func _load_level(index):
	if current_level != null:
		current_level.queue_free()
		
	var level = levels[index]
	current_level = level.instantiate()
	add_child(current_level)
	move_child(current_level, 0)
	
	var player_marker: Marker2D
	var son_marker: Marker2D
	
	if out_way:
		player_marker = current_level.player_pos_out
		son_marker = current_level.son_pos_out
	else:
		player_marker = current_level.player_pos_in
		son_marker = current_level.son_pos_in
	
	$Player.set_global_position(player_marker.global_position)
	$Son.set_global_position(son_marker.global_position)

	$Son.visible = out_way or current_index >= (levels.size() - 1)

func next_level(in_way: bool):
	if in_way != self.out_way:
		return

	if out_way:
		if current_index == 0:
			return # end game
		else:
			current_index -= 1
	else:
		if current_index == levels.size() - 1:
			current_index -= 1
		else:
			current_index += 1
			if current_index == levels.size() - 1:
				out_way = true

	_load_level(current_index)

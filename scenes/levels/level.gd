extends Node2D

@export var door_in: Marker2D = null
@export var door_out: Marker2D = null

@export var player_pos_in: Marker2D = null
@export var player_pos_out: Marker2D = null

@export var son_pos_in: Marker2D = null
@export var son_pos_out: Marker2D = null

var door_scene: PackedScene = preload("res://scenes/objects/door.tscn")

func _ready():
	spawn_doors()
	
func spawn_doors():
	var door_in_node = door_scene.instantiate()
	door_in_node.set_way(true)
	door_in.add_child(door_in_node)
	
	var door_out_node = door_scene.instantiate()
	door_out_node.set_way(false)
	door_out.add_child(door_out_node)


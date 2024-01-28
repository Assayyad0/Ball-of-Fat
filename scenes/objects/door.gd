extends Area2D

var player: Area2D = null
var son: Area2D = null
var in_way: bool = true

func set_way(in_way: bool):
	self.in_way = in_way

func _on_area_entered(area):
	var parent = area.get_parent()
	
	if parent.name == "Player":
		player = area
		
	if parent.name == "Son":
		son = area
	
	if player and (!in_way or son):
		var level_manager = get_parent().get_parent().get_parent().get_parent()
		level_manager.next_level(in_way)

func _on_area_exited(area):
	var parent = area.get_parent()
	
	if parent.name == "Player":
		player = null
		
	if parent.name == "Son":
		son = null

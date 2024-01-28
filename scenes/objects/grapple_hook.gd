extends Node2D

signal hook_reached_point(pos)
signal hook_canceled

var hook_scene: PackedScene = preload("res://scenes/objects/hook.tscn")

@export var speed: float = 100

var moving: bool = false
var hook_pos: Vector2
var hook: Area2D = null
var hook_timer: Timer = null
var dir: Vector2 = Vector2.ZERO

func _ready():
	hook = hook_scene.instantiate()
	hook.visible = false
	hook.connect("area_entered", _on_hook_area_entered)

	hook_timer = hook.get_node("Timer")
	hook_timer.connect("timeout", _on_timer_timeout)
	
	get_tree().get_root().add_child.call_deferred(hook)

func _process(delta):	
	if moving:
		hook.global_position += dir * speed * delta
		look_at(get_global_mouse_position())
	else: 
		if hook_pos != Vector2.ZERO:
			hook.global_position = hook_pos
			look_at(hook_pos)
		else:
			look_at(get_global_mouse_position())
	
func shoot():
	if hook == null or hook_timer == null or hook.visible == true:
		return

	hook.global_position = $Sprite2D/ShootingPoint.global_position
	hook.visible = true
	hook_timer.start()
	
	dir = (get_global_mouse_position() - hook.global_position).normalized()
	moving = true
	
func check_distance(pos: Vector2):
	if hook.global_position.distance_to(pos) <= 10:
		end_grappling()
		
func end_grappling():
	hook.visible = false
	moving = false
	hook_pos = Vector2.ZERO
	hook_canceled.emit()

func _on_hook_area_entered(area):
	print(area)		
	if area.name.begins_with("HookPoint"):
		hook_timer.stop()
		hook_pos = area.global_position
		moving = false
		hook_reached_point.emit(hook.global_position)
	else:
			end_grappling()

func _on_timer_timeout():
	end_grappling()

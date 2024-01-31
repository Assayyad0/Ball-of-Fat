extends Node2D

@export var speed: float = 100
@export var min_dis: float = 20
@export var max_dis: float = 200
@export var _hook_scene: PackedScene = preload("res://scenes/objects/hook.tscn")

var shooting_point: Node2D
var movement: Node2D
var player: CharacterBody2D

var _dir: Vector2 = Vector2.ZERO
# NOTE: if _hook isn't visible, then state is "off", other possble values are "shoot", "return", "pull"
var _state: String = "off"
var _hook: Area2D
var _scale_y: float

var enabled: bool = true: set = _set_enabled
func _set_enabled(value: bool):
	enabled = value
	self.visible = value

func shoot():
	if not enabled or _hook == null or _hook.visible == true:
		return

	_hook.global_position = shooting_point.global_position
	_hook.visible = true
	
	var mouse_pos = get_global_mouse_position()
	_dir = (mouse_pos - _hook.global_position).normalized()
	_hook.look_at(mouse_pos)
	self._state = "shoot"

func _ready():
	shooting_point = $Sprite2D/ShootingPoint
	movement = $"../Movement"
	player = $".."
	_scale_y = $Sprite2D.scale.y

	_hook = _hook_scene.instantiate()
	_hook.connect("area_entered", _on_hook_area_entered)
	_hook.set_shooting_point(shooting_point)
	self._stop()
	
	get_tree().get_root().add_child.call_deferred(_hook)

func _process(delta):	
	if self._state == "shoot":
		_hook.global_position += _dir * speed * delta
		if _hook.global_position.distance_to(shooting_point.global_position) >= max_dis:
			_return_hook()
			return
	elif self._state == "pull":
		player.global_position += _dir * speed * delta
	elif self._state == "return":
		_dir = (shooting_point.global_position - _hook.global_position).normalized()
		_hook.global_position += _dir * speed * delta * 2.0

	if self._state == "pull" or self._state == "return":
		if _hook.global_position.distance_to(shooting_point.global_position) < min_dis:
			self._stop()

	if _hook.visible:
		look_at(_hook.global_position)
	else:
		look_at(get_global_mouse_position())	
	
	var degrees = _get_degrees(rotation_degrees)
	if degrees > 90 and degrees <= 275:
		$Sprite2D.scale.y = -_scale_y
	else:
		$Sprite2D.scale.y = _scale_y

func _get_degrees(degrees):
	while(degrees < 0 or degrees > 360):
		if degrees < 0:
			degrees += 360
		elif degrees > 360:
			degrees -= 360
	return degrees

func _return_hook():
	self._state = "return"
	movement.enabled = true

func _stop():
	self._state = "off"
	_hook.visible = false
	movement.enabled = true

func _on_hook_area_entered(area):
	if not area.name.begins_with("HookPoint"):
		_return_hook()
		return

	self._state = "pull"
	_hook.global_position = area.global_position
	_dir = (area.global_position - shooting_point.global_position).normalized()
	movement.enabled = false
	player.velocity = Vector2.ZERO

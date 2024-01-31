extends Node2D

@export var speed: float = 100

var x_scale: float = 1
var player: CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var enabled: bool = true: set = _set_enabled
func _set_enabled(value: bool):
	enabled = value
	self.visible = value

func _ready():
	player = $".."
	x_scale = player.scale.x
	
func _physics_process(delta):
	if not enabled:
		return

	if not player.is_on_floor():
		player.velocity.y += gravity * delta
	else:
		player.velocity.y = 0

	var dir = int(Input.get_axis("left", "right"))
	player.velocity.x = dir * speed
		
	if dir < 0:
		if player.scale.y > 0:
			player.scale.x = -x_scale
	if dir > 0:
		if player.scale.y < 0:
			player.scale.x = -x_scale
	
	player.move_and_slide()


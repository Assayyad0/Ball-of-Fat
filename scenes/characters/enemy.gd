extends CharacterBody2D


@export var speed: float = 300
@export var flip_check_dis: float = 1
@export var points: Array[float] = [-50, 50]

var current_point_index: int = 0
var fov_pos: float
var original_x: float
var player: Area2D = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	fov_pos = $FieldOfView/CollisionShape2D.position.x
	original_x = position.x

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	var target: float
	
	if player:
		target = player.global_position.x
	else:
		target = original_x + points[current_point_index]
	var dir: float = sign(target - position.x)
	velocity.x = dir * speed
	
	if absf((position.x - target)) < flip_check_dis:
		current_point_index = (current_point_index + 1) % points.size()

	if dir < 0:
		$Sprite2D.flip_h = false
		$FieldOfView/CollisionShape2D.position.x = -fov_pos
	if dir > 0:
		$Sprite2D.flip_h = true
		$FieldOfView/CollisionShape2D.position.x = fov_pos
		
	move_and_slide()


func _on_area_2d_area_entered(area):
	current_point_index = (current_point_index + 1) % points.size()


func _on_field_of_view_area_entered(area):
	player = area

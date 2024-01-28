extends CharacterBody2D

@export var speed: float = 300
@export var flip_check_dis: float = 1
@export var points: Array[float] = [-50, 50]

var current_point_index: int = 0
var fov_pos: float
var original_x: float
var dead: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	fov_pos = $FieldOfView/CollisionShape2D.position.x
	original_x = position.x

func _physics_process(delta):
	if self.dead:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	var target: float = original_x + points[current_point_index]
	var dir: float = sign(target - position.x)
	velocity.x = dir * speed
	
	if absf((position.x - target)) < flip_check_dis:
		current_point_index = (current_point_index + 1) % points.size()

	if dir < 0:
		$Sprite2D.flip_h = false
		$Gun.flip_h = false
		$Gun.position.x = -6.5
		$FieldOfView/CollisionShape2D.position.x = -fov_pos
	if dir > 0:
		$Sprite2D.flip_h = true
		$Gun.flip_h = true
		$Gun.position.x = 6.5
		$FieldOfView/CollisionShape2D.position.x = fov_pos
		
	move_and_slide()


func die():	
	remove_child($CollisionShape2D)
	remove_child($Area2D)
	remove_child($FieldOfView)
	
	global_scale.y = 0.5
	self.dead = true


func _on_area_2d_area_entered(area):
	current_point_index = (current_point_index + 1) % points.size()


func _on_field_of_view_area_entered(area):
	var parent = area.get_parent()
	if parent.name == "Player":
		parent.die()

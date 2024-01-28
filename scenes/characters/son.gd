extends CharacterBody2D

@export var bounce_factor: float = 0.5
@export var bounce_division: int = 4
@export var force: float = 1200

var thrown: bool = false
var current_bounce_factor: float

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	velocity.y += gravity * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * current_bounce_factor

func throw():
	self.thrown = true
	var dir = (get_global_mouse_position() - global_position).normalized()
	velocity = dir * force
	current_bounce_factor = bounce_factor

func _on_body_entered(body: PhysicsBody2D):
	current_bounce_factor /= bounce_division
	if current_bounce_factor <= 0.1:
		self.thrown = false


func _on_area_2d_area_entered(area):
	if self.thrown:
		area.get_parent().die()

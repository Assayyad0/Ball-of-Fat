extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var bounce_factor = 0.5

func _physics_process(delta):
	velocity.y += gravity * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * bounce_factor

func _on_body_entered(body: PhysicsBody2D):
	bounce_factor /= 2

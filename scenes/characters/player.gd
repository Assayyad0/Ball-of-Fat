extends CharacterBody2D

@export var speed: float = 10
@export var throw_force: float = 1000

var can_move: bool = true
var grapple_direction: Vector2 = Vector2.ZERO
var grabbed_son: CharacterBody2D = null
var x_scale: float = 1
var want_to_throw
var grabber_pos: float
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	x_scale = self.scale.x
	grabber_pos = $Grabber/CollisionShape2D.position.x

func _process(delta):
	if grabbed_son != null:
		grabbed_son.global_position = $Hand.global_position

	grapple()
	grab()

func _physics_process(delta):
	if grapple_direction != Vector2.ZERO:
		position += grapple_direction * speed * delta * 3
		$GrappleHook.check_distance(global_position)
	else:
		move(delta)
		
	if !want_to_throw or grabbed_son == null:
		return

	var dir = (get_global_mouse_position() - grabbed_son.global_position).normalized()
	grabbed_son.velocity = dir * throw_force
	grabbed_son = null
	want_to_throw = false

func move(delta):
	if !can_move:
		return

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	var dir = int(Input.get_axis("left", "right"))
	velocity.x = dir * speed
		
	if dir < 0:
		$Sprite2D.flip_h = true
		$Grabber/CollisionShape2D.position.x = -grabber_pos
	if dir > 0:
		$Sprite2D.flip_h = false
		$Grabber/CollisionShape2D.position.x = grabber_pos
	
	move_and_slide()
	
func grapple():
	if Input.is_action_just_pressed("grapple"):
		$GrappleHook.visible = true
		$GrappleHook.shoot()

func grab():
	if Input.is_action_just_pressed("grab"):
		if grabbed_son == null:
			var bodies = $Grabber.get_overlapping_bodies()
			for body in bodies:
				if body.name == "Son":
					grabbed_son = body
					break
		else:
			want_to_throw = true

func _on_grapple_hook_hook_reached_point(pos):
	can_move = false
	velocity.y = 0
	grapple_direction = (pos - position).normalized()

func _on_grapple_hook_hook_canceled():
	can_move = true
	grapple_direction = Vector2.ZERO

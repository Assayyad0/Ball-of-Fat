extends CharacterBody2D

@export var speed: float = 10
@export var throw_force: float = 1000

var can_move: bool = true
var grapple_direction: Vector2 = Vector2.ZERO
var grabbed_son: CharacterBody2D = null
var x_scale: float = 1
var want_to_throw

func _ready():
	x_scale = self.scale.x

func _process(delta):
	if grapple_direction != Vector2.ZERO:
		position += grapple_direction * speed * delta * 3
		$GrappleHook.check_distance(global_position)
	else:
		move()

	if grabbed_son != null:
		grabbed_son.global_position = $Hand.global_position

	grapple()
	grab()

func _physics_process(delta):
	if !want_to_throw or grabbed_son == null:
		return

	var dir = (get_global_mouse_position() - grabbed_son.global_position).normalized()
	grabbed_son.velocity = dir * throw_force
	grabbed_son = null
	want_to_throw = false

func move():
	if !can_move:
		return

	velocity.y = 500

	var axis = int(Input.get_axis("left", "right"))
	if axis == 0:
		velocity.x = 0
	else:
		velocity.x = axis * speed
		
		if axis < 0:
			$Sprite2D.flip_h = true
			$Grabber/CollisionShape2D.position.x = -15
		if axis > 0:
			$Sprite2D.flip_h = false
			$Grabber/CollisionShape2D.position.x = 15
	
	move_and_slide()
	
func grapple():
	if Input.is_action_just_pressed("grapple") and is_on_floor():
		# can_move = false
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
	grapple_direction = (pos - position).normalized()

func _on_grapple_hook_hook_canceled():
	can_move = true
	grapple_direction = Vector2.ZERO

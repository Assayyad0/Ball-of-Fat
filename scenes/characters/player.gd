extends CharacterBody2D

@export var speed: float = 10

var grapple_direction: Vector2 = Vector2.ZERO
var grabbed_son: CharacterBody2D = null
var grabber_pos: float

func _ready():
	grabber_pos = $Grabber/CollisionShape2D.position.x

func _process(_delta):
	if grabbed_son != null:
		grabbed_son.global_position = $Hand.global_position

	if Input.is_action_just_pressed("grapple"):
		$GrappleHook.shoot()
		
	if Input.is_action_just_pressed("grab"):
		if grabbed_son == null:
			var bodies = $Grabber.get_overlapping_bodies()
			for body in bodies:
				if body.name == "Son":
					grabbed_son = body
					$GrappleHook.enabled = false
					$Sprites/Idle.visible = false
					$Sprites/Carry.visible = true
					break
		else:
			grabbed_son.throw()
			grabbed_son = null
			$GrappleHook.enabled = true
			$Sprites/Idle.visible = true
			$Sprites/Carry.visible = false

func die():
	get_parent().remove_child(self)

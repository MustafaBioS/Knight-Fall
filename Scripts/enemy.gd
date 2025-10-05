extends CharacterBody3D

enum States {attack, idle, chase, die}

var state = States.idle
var hp = 75
var speed = 2
var accel = 10
var gravity = 9.8
var target = null

@onready var navagent = $"NavigationAgent3D"
@onready var animation = $"AnimationPlayer"


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity
	if state == States.idle:
		velocity = Vector3.ZERO
		animation.play("")
	elif state == States.chase:
		look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP, true)
		navagent.target_position = target.global_position
		var direction = navagent.get_next_path_position() - global_position
		direction = direction.normalized() 
		velocity = velocity.lerp(direction * speed, accel * delta)
		animation.play("")
	elif state == States.attack:
		look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP, true)
		velocity = Vector3.ZERO
		animation.play("SwordSwing")
	elif state == States.die:
		velocity = Vector3.ZERO
		animation.play("")
		
	move_and_slide()
	
func _on_chase_area_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		target = body
		state = States.chase

func _on_chase_area_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		target = null
		state = States.idle

func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		
		state = States.attack
func _on_attack_area_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		
		state = States.chase	

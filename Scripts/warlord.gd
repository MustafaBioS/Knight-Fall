extends CharacterBody3D

var player_in_area = false

func _on_talk_area_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		player_in_area = true

func _on_talk_area_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		player_in_area = false

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		start_dialogue()

func start_dialogue():
	print("Dialogue started!")

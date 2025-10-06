extends CharacterBody3D

@export var dialogue: DialogueResource;

var player_in_area = false

func _on_talk_area_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		player_in_area = true


func _on_talk_area_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		player_in_area = false

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		DialogueManager.show_dialogue_balloon(dialogue)

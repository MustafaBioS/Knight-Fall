extends Node3D

var player_in_area = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		player_in_area = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		player_in_area = false

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/shop.tscn")

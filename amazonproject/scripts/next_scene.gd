extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://scenes/Dungeons/MataDaTerraFirme/dungeon_1.tscn")
		
	pass # Replace with function body.

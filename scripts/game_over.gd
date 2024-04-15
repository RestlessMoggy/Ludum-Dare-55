extends Node2D


func _process(delta):
	$TextureRect.position -= Vector2(4, 4)
	if $TextureRect.position.x <= -256:
		$TextureRect.position = Vector2.ZERO


func _on_quit_button_pressed():
	get_tree().quit()



func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

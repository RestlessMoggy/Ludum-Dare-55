extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TextureRect.position -= Vector2(4, 4)
	if $TextureRect.position.x <= -256:
		$TextureRect.position = Vector2.ZERO


func _on_quit_button_pressed():
	get_tree().quit()



func _on_restart_button_pressed():
	get_tree()
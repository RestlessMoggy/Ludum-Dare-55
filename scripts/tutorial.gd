extends Node2D

@onready var next_button_position = $NextButton.position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_next_button_pressed():
	if $Slides.position.x != 1920 * -4:
		$Slides.position.x -= 1920
	else:
		$Slides.position.x = 0
		


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

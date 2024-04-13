extends Node2D

class_name Hero

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	SUPER_RARE,
	ULTRA_RARE,
}

enum Status {
	GOING_TO_MINE,
	MINING,
	GOING_BACK_FROM_MINE,
	FIGHTING
}

@export var status = Status.GOING_TO_MINE
var rarity = Rarity.COMMON

var health = 100
var attack = 10
@export var speed = 10

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func mine():
	$Timer.start()


func _on_timer_timeout():
	if status == Status.MINING:
		status = Status.GOING_BACK_FROM_MINE

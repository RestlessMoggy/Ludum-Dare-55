extends CharacterBody2D

class_name Hero

signal death(hero)

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

var max_health = 100
var health = 100
var attack = 10
@export var speed = 100

func _ready():
	pass

func _process(delta):
	pass

func mine():
	$Timer.start()

func die():
	death.emit(self)

func generate_stats(rarity):
	pass

func hit():
	health -= 30
	if health <= 0:
		die()
		
	$HealthBar.scale.x = $Sprite2D.scale.x * health / max_health

func _on_timer_timeout():
	if status == Status.MINING:
		status = Status.GOING_BACK_FROM_MINE


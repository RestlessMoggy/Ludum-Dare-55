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

var base_health = 120
var base_attack = 25
var base_speed = 300

var max_health = 120
var health = max_health
@export var attack = 100
@export var speed = 250

var health_bar_ratio = 0.1

var aura_color = {
	"common": "7c512d",
	"uncommon": "ff001e",
	"rare": "5e74bb",
	"super": "ffffff",
	"ultra": "fe43e",
}

var rng = RandomNumberGenerator.new()

func mine():
	$Timer.start()

func die():
	death.emit(self)

func generate_stats(rarity):
	var modifier = 1
	var speed_modifier = 1
	var rarity_sprite = $RaritySprite
	if rarity == Rarity.COMMON:
		rarity_sprite.modulate = aura_color["common"]
		if rng.randf() < 0.1:
			rarity = Rarity.UNCOMMON
	if rarity == Rarity.UNCOMMON:
		rarity_sprite.modulate = aura_color["uncommon"]
		modifier = 1.1
		speed_modifier = 1.1
		if rng.randf() < 0.1:
			rarity = Rarity.RARE
	if rarity == Rarity.RARE:
		rarity_sprite.modulate = aura_color["rare"]
		modifier = 1.5
		speed_modifier = 1.2
		if rng.randf() < 0.1:
			rarity = Rarity.SUPER_RARE
	if rarity == Rarity.SUPER_RARE:
		modifier = 3.5
		speed_modifier = 1.3
		rarity_sprite.modulate = aura_color["super"]
		if rng.randf() < 0.1:
			rarity = Rarity.ULTRA_RARE
	if rarity == Rarity.ULTRA_RARE:
		rarity_sprite.modulate = aura_color["ultra"]
		modifier = 4.0
		speed_modifier = 1.4
	max_health = base_health * (1 + rng.randf_range(-0.1, 0.25)) * modifier
	attack = base_attack * (1 + rng.randf_range(-0.1, 0.25)) * modifier
	speed = base_speed * (1 + rng.randf_range(-0.1, 0)) * speed_modifier
	health = max_health
	
	

func hit():
	health -= 10
	if health <= 0:
		die()
		
	$HealthBar.scale.x = health_bar_ratio * health / max_health

func _on_timer_timeout():
	if status == Status.MINING:
		status = Status.GOING_BACK_FROM_MINE


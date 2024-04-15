extends Node2D

@onready var projectile_scene = preload("res://scenes/projectile.tscn")

const PROJECTILE_SPEED = 1500

var fighter_list = []
var miner_list = []

var is_shooting

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attack_area_body_entered(body):
	if body is Hero:
		if body.status == Hero.Status.FIGHTING:
			fighter_list.append(body)
		else:
			miner_list.append(body)


func _on_attack_area_body_exited(body):
	if body is Hero:
		if body.status == Hero.Status.FIGHTING:
			fighter_list.erase(body)
		else:
			miner_list.erase(body)


func _on_attack_timer_timeout():
	var hero = find_target()
	if hero != null:
		is_shooting = true
		$AnimatedSprite2D.play("shooting")
		var projectile = projectile_scene.instantiate()
		var projectile_direction = (hero.global_position - global_position).normalized()
		
		if projectile_direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
			
		projectile.direction = projectile_direction
		projectile.look_at(projectile_direction)
		$Projectiles.add_child(projectile)


func find_target():
	if len(miner_list) == 0 and len(fighter_list) == 0:
		return null
	if len(fighter_list) > 0:
		var furthest_length = 0
		var furthest_fighter = fighter_list[0]
		for fighter in fighter_list:
			if fighter.get_parent().progress > furthest_length:
				furthest_length = fighter.get_parent().progress
				furthest_fighter = fighter
		return furthest_fighter
	if len(miner_list) > 0:
		var furthest_status = Hero.Status.GOING_TO_MINE
		for miner in miner_list:
			if miner.status == Hero.Status.GOING_BACK_FROM_MINE:
				furthest_status = Hero.Status.GOING_BACK_FROM_MINE
		var furthest_miner = null
		var furthest_length = 0
		if furthest_status == Hero.Status.GOING_BACK_FROM_MINE:
			furthest_length = 1
		
		for miner in miner_list:
			if miner.status == furthest_status:
				if furthest_status == Hero.Status.GOING_TO_MINE:
					if miner.get_parent().progress_ratio > furthest_length:
						furthest_miner = miner
						furthest_length = miner.get_parent().progress_ratio
				if furthest_status == Hero.Status.GOING_BACK_FROM_MINE:
					if miner.get_parent().progress_ratio < furthest_length:
						furthest_miner = miner
						furthest_length = miner.get_parent().progress_ratio
		return furthest_miner


func remove_hero_from_queue(hero):
	miner_list.erase(hero)
	fighter_list.erase(hero)


func _on_animated_sprite_2d_animation_finished():
	if is_shooting:
		$AnimatedSprite2D.play("default")
		is_shooting = false

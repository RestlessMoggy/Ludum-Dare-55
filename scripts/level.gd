extends Node2D

@onready var hero_scene = preload("res://scenes/hero.tscn")

var heroes = []

var magic_stones = 100

var demon_lord_hp = 100

func _ready():
	for path_follow in $MiningPath.get_children():
		heroes.append(path_follow.get_child(0)) 
	for path_follow in $FightingPath.get_children():
		heroes.append(path_follow.get_child(0)) 
	print(len(heroes))

func _process(delta):
	if Input.is_action_just_pressed("summon"):
		summon_hero(Hero.Rarity.COMMON, Hero.Status.FIGHTING)
		summon_hero(Hero.Rarity.COMMON, Hero.Status.GOING_TO_MINE)

func _physics_process(delta):
	for hero in heroes:
		if hero.status == Hero.Status.GOING_TO_MINE:
			var current_progress_ratio = hero.get_parent().progress_ratio
			hero.get_parent().progress += hero.speed * delta
			if current_progress_ratio > hero.get_parent().progress_ratio:
				hero.status = Hero.Status.MINING
				hero.get_parent().progress_ratio = 1
				hero.mine()
		if hero.status == Hero.Status.FIGHTING:
			var current_progress_ratio = hero.get_parent().progress_ratio
			hero.get_parent().progress += hero.speed * delta
			if current_progress_ratio > hero.get_parent().progress_ratio:
				hero.status = Hero.Status.MINING
				hero.get_parent().progress_ratio = 1
				calculate_damage(hero)
		if hero.status == Hero.Status.GOING_BACK_FROM_MINE:
			var current_progress_ratio = hero.get_parent().progress_ratio
			hero.get_parent().progress -= hero.speed * delta
			if current_progress_ratio < hero.get_parent().progress_ratio:
				magic_stones += 5
				reload_ui()
				hero.status = Hero.Status.GOING_TO_MINE
				hero.get_parent().progress_ratio = 0
				hero.mine()

func reload_ui():
	$MagicStonesLabel.text = "Magic Stones: " + str(magic_stones)
	$DemonLordHP.text = str(demon_lord_hp)

func calculate_damage(hero):
	demon_lord_hp -= hero.attack
	if demon_lord_hp > 0:
		heroes.erase(hero)
		hero.get_parent().queue_free()
		reload_ui()
	else:
		show_win_screen()

func summon_hero(rarity, task):
	var hero = hero_scene.instantiate()
	
	hero.death.connect(on_hero_death)
	
	var cost = 0
	match rarity:
		Hero.Rarity.COMMON:
			cost = 25
		Hero.Rarity.UNCOMMON:
			cost = 50
		Hero.Rarity.RARE:
			cost = 100
		Hero.Rarity.SUPER_RARE:
			cost = 150
		Hero.Rarity.ULTRA_RARE:
			cost = 250
	
	if cost != 0 and magic_stones - cost >= 0:
		magic_stones -= cost
		reload_ui()
		hero.rarity = rarity
		hero.generate_stats(rarity)
		hero.status = task
		match task:
			Hero.Status.GOING_TO_MINE:
				var path_follow = PathFollow2D.new()
				$MiningPath.add_child(path_follow)
				path_follow.add_child(hero)
			Hero.Status.FIGHTING:
				var path_follow = PathFollow2D.new()
				$FightingPath.add_child(path_follow)
				path_follow.add_child(hero)
			_:
				hero.status = Hero.Status.GOING_TO_MINE
				var path_follow = PathFollow2D.new()
				$MiningPath.add_child(path_follow)
				path_follow.add_child(hero)
		heroes.append(hero)


func show_win_screen():
	pass


func on_hero_death(hero):
	heroes.erase(hero)
	for monster in $Enemies.get_children():
		monster.remove_hero_from_queue(hero)
	hero.queue_free()

extends Node2D

var heroes = []

var magic_stones = 0

var demon_lord_hp = 100

func _ready():
	for path_follow in $MiningPath.get_children():
		heroes.append(path_follow.get_child(0)) 
	for path_follow in $FightingPath.get_children():
		heroes.append(path_follow.get_child(0)) 
	print(len(heroes))


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

func show_win_screen():
	pass

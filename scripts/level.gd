extends Node2D

@onready var hero_scene = preload("res://scenes/hero.tscn")

@onready var common_button = $UI/TabContainer/Summoning/ScrollContainer/VBoxContainer/HBoxContainer/CommonButton
@onready var uncommon_button = $UI/TabContainer/Summoning/ScrollContainer/VBoxContainer/HBoxContainer2/UncommonButton
@onready var rare_button = $UI/TabContainer/Summoning/ScrollContainer/VBoxContainer/HBoxContainer3/RareButton
@onready var sr_button = $UI/TabContainer/Summoning/ScrollContainer/VBoxContainer/HBoxContainer4/SRButton
@onready var ur_button = $UI/TabContainer/Summoning/ScrollContainer/VBoxContainer/HBoxContainer5/URButton
@onready var task_menu = $UI/TabContainer/Summoning/ScrollContainer/VBoxContainer/OptionButton



var heroes = []

var magic_stones = 100

var goblin_king_max_hp = 500

var goblin_king_hp = 500

var goblin_king_hurt = false

func _ready():
	for path_follow in $MiningPath.get_children():
		heroes.append(path_follow.get_child(0)) 
	for path_follow in $FightingPath.get_children():
		heroes.append(path_follow.get_child(0)) 
	reload_ui()

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
				magic_stones += 15
				reload_ui()
				hero.status = Hero.Status.GOING_TO_MINE
				hero.get_parent().progress_ratio = 0
				hero.mine()

func reload_ui():
	$UI/MagicStonesLabel.text = "X " + str(magic_stones)
	common_button.disabled = true
	uncommon_button.disabled = true
	rare_button.disabled = true
	sr_button.disabled = true
	ur_button.disabled = true
	if magic_stones >= 25:
		common_button.disabled = false
	if magic_stones >= 50:
		uncommon_button.disabled = false
	if magic_stones >= 100:
		rare_button.disabled = false
	if magic_stones >= 150:
		sr_button.disabled = false
	if magic_stones >= 250:
		ur_button.disabled = false

func calculate_damage(hero):
	goblin_king_hp -= hero.attack
	goblin_king_hurt = true
	$GoblinKing.play("hurt")
	$GoblinKing/HealthBar.scale.x = 0.75 * goblin_king_hp / goblin_king_max_hp
	if goblin_king_hp > 0:
		heroes.erase(hero)
		hero.get_parent().queue_free()
		reload_ui()
		check_lose_condition()
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
				path_follow.rotates = false
				$MiningPath.add_child(path_follow)
				path_follow.add_child(hero)
			Hero.Status.FIGHTING:
				var path_follow = PathFollow2D.new()
				path_follow.rotates = false
				$FightingPath.add_child(path_follow)
				path_follow.add_child(hero)
			_:
				hero.status = Hero.Status.GOING_TO_MINE
				var path_follow = PathFollow2D.new()
				path_follow.rotates = false
				$MiningPath.add_child(path_follow)
				path_follow.add_child(hero)
		heroes.append(hero)


func show_win_screen():
	get_tree().change_scene_to_file("res://scenes/win.tscn")


func on_hero_death(hero):
	heroes.erase(hero)
	for monster in $Enemies.get_children():
		monster.remove_hero_from_queue(hero)
	hero.queue_free()
	check_lose_condition()



func _on_common_button_pressed():
	if task_menu.selected == 0:
		summon_hero(Hero.Rarity.COMMON, Hero.Status.FIGHTING)
	if task_menu.selected == 1:
		summon_hero(Hero.Rarity.COMMON, Hero.Status.GOING_TO_MINE)


func _on_uncommon_button_pressed():
	if task_menu.selected == 0:
		summon_hero(Hero.Rarity.UNCOMMON, Hero.Status.FIGHTING)
	if task_menu.selected == 1:
		summon_hero(Hero.Rarity.UNCOMMON, Hero.Status.GOING_TO_MINE)


func _on_rare_button_pressed():
	if task_menu.selected == 0:
		summon_hero(Hero.Rarity.RARE, Hero.Status.FIGHTING)
	if task_menu.selected == 1:
		summon_hero(Hero.Rarity.RARE, Hero.Status.GOING_TO_MINE)


func _on_sr_button_pressed():
	if task_menu.selected == 0:
		summon_hero(Hero.Rarity.SUPER_RARE, Hero.Status.FIGHTING)
	if task_menu.selected == 1:
		summon_hero(Hero.Rarity.SUPER_RARE, Hero.Status.GOING_TO_MINE)


func _on_ur_button_pressed():
	if task_menu.selected == 0:
		summon_hero(Hero.Rarity.ULTRA_RARE, Hero.Status.FIGHTING)
	if task_menu.selected == 1:
		summon_hero(Hero.Rarity.ULTRA_RARE, Hero.Status.GOING_TO_MINE)


func _on_goblin_king_animation_finished():
	if goblin_king_hurt:
		goblin_king_hurt = false
		$GoblinKing.play("idle")

func check_lose_condition():
	if len(heroes) == 0 and magic_stones < 25:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

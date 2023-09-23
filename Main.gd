extends Node

@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var cactus_scene:PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var obstacles = 1
var screensize = Vector2.ZERO
var playing = false



# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		obstacles += 1
		time_left += 5
		spawn_coins()

func new_game():
	$CactusTimer.start()
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	$PowerupTimer.start()
	spawn_coins()
	
func spawn_coins():
	$LevelSound.play()
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0,screensize.x),randi_range(0,screensize.y))

func spawn_powerups():
	var c =  powerup_scene.instantiate()
	add_child(c)
	c.screensize = screensize
	c.position = Vector2(randi_range(0,screensize.x),randi_range(0,screensize.y))
	
func _on_game_timer_timeout():
	time_left-= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func game_over():
	playing = false;
	$GameTimer.stop()
	$PowerupTimer.stop()
	$CactusTimer.stop()
	get_tree().call_group("coins","queue_free")
	get_tree().call_group("powerup","queue_free")
	get_tree().call_group("obstacles","queue_free")
	$HUD.show_game_over()
	$Player.die()
	$EndSound.play()
	


func _on_player_hurt():
	game_over()


func _on_player_pickup(type):
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerUps.play()
			time_left += 5
			$HUD.update_timer(time_left)
			

func _on_hud_start_game():
	new_game()


func _on_power_ups_appear_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0,screensize.x),randi_range(0,screensize.y))
	$PowerupTimer.set_wait_time(randf_range(3,8))
	$PowerupTimer.start()
	
	


func _on_player_powerup():
	time_left += 20
	$HUD.update_timer(time_left)
	$PowerUps.play()
	


func _on_cactus_timer_timeout():
	get_tree().call_group("obstacles","queue_free")	
	
	for i in randi_range(1,obstacles):
		spawn_obstacles()
	
	$CactusTimer.set_wait_time(randf_range(5,8))
	$CactusTimer.start()
		
	

func spawn_obstacles():
	var p = cactus_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0,screensize.x),randi_range(0,screensize.y))
	



func _on_player_game_over():
	game_over()

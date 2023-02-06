extends Node

export(PackedScene) var mob_scene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()


func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_MobTimer_timeout():
	# Create new instance of Mob scene
	var mob = mob_scene.instance()
	
	# Choose random location on Path2D
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	# Set mob's direction perpendicular to path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set mob's position to random location
	mob.position = mob_spawn_location.position
	
	# Add some randomness to direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose velocity for mob
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn mob by adding it to Main scene
	add_child(mob)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

extends Area2D

signal hit

export var speed = 400 # Player movement speed (pixels/sec)
var screen_size # Size of game window


func _ready():
	screen_size = get_viewport_rect().size
	hide() # Hide player when game starts


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _process(delta):
	# Detect input for player movement
	var velocity = Vector2.ZERO # Player's movement vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	# Calculate and show player movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	# Restrict movement area
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Show animation according to input
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide() # Player disappears after being hit
	emit_signal("hit")
	# Disable player's collision to prevent triggering hit signal more than once
	# Note: Disabling the area's collision shape can cause an error if it
	#       happens in the middle of the engine's collision processing.
	#       Using set_deferred() tells Godot to wait to disable the shape
	#       until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true)

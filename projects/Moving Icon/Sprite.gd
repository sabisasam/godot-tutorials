extends Sprite

var speed = 400
var angular_speed = PI
var movement = "auto"


func _ready():
	var timer = get_node("Timer")
	# Connect Timer's "timeout" signal to this node (self),
	# call function "_on_Timer_timeout" when signal emitted
	timer.connect("timeout", self, "_on_Timer_timeout")


func move_via_input(delta):
	# Function gets called if movement = "input"
	# Determine direction
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1
	# Calculate rotation
	rotation += angular_speed * direction * delta
	# Determine velocity
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP.rotated(rotation) * speed
	# Calculate position
	position += velocity * delta


func move_automatically(delta):
	# Function gets called if movement = "auto"
	# Calculate rotation
	rotation += angular_speed * delta
	# Determine velocity
	var velocity = Vector2.UP.rotated(rotation) * speed
	# Calculate position
	position += velocity * delta


func _process(delta):
	if movement == "auto":
		move_automatically(delta)
	elif movement == "input":
		move_via_input(delta)


func _on_ButtonToggle_pressed():
	set_process(not is_processing())


func _on_ButtonControl_toggled(button_pressed):
	if button_pressed:
		movement = "input"
	else:
		movement = "auto"


func _on_Timer_timeout():
	visible = not visible

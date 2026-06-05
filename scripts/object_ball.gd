extends CharacterBody2D

# Signal emitted when the ball goes past a player's paddle.
signal out_of_bounds(side: Globals.Side)

# The speed of the ball.
@export var speed = 200

var initial_velocity = Vector2.ZERO

func _ready():
	# Start the game with the ball moving.
	start()

# This function is called from the main scene to reset the ball.
func start():
	position = get_viewport_rect().size / 2
	# Choose a random starting direction, either left or right.
	var direction_x = 1.0 if randf() > 0.5 else -1.0
	var direction_y = randf_range(-0.5, 0.5)
	
	initial_velocity = Vector2(direction_x, direction_y).normalized() * speed
	velocity = initial_velocity


func _physics_process(delta):
	# Check if the ball is out of the screen horizontally
	if position.x < 0:
		out_of_bounds.emit(Globals.Side.LEFT)
		# Reset the ball to the center
		start()
	elif position.x > get_viewport_rect().size.x:
		out_of_bounds.emit(Globals.Side.RIGHT)
		# Reset the ball to the center
		start()
	
	if position.y < 0 or position.y > get_viewport_rect().size.y:
		# Reset the ball to the center
		start()

	# Move the ball and get collision information
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		# If a collision occurs, bounce the ball.
		# The bounce function reflects the velocity vector based on the collision normal.
		velocity = velocity.bounce(collision.get_normal())
		# Optional: slightly increase speed on each paddle hit to make the game more challenging
		var collider = collision.get_collider()
		if collider and collider.is_in_group("paddles"):
			velocity *= 1.05

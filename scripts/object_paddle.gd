extends CharacterBody2D

@export var side: Globals.Side = Globals.Side.LEFT
@export var is_ai: bool = false
@export var speed: float = 600.0
@export var stop_time: float = 0.25

var padding: int = 50
var _current_velocity := Vector2.ZERO
var _anchor_x: float
var _ball: CharacterBody2D
var _ai_offset: float
var _ai_offset_timer: float

func _ready():
	_ball = get_tree().current_scene.get_node("Game/Ball")
	
	var screen_size = get_viewport_rect().size
	var y_pos = screen_size.y / 2

	if side == Globals.Side.LEFT:
		_anchor_x = padding
		self.position.x = _anchor_x
		self.position.y = y_pos
	else:
		_anchor_x = screen_size.x - padding
		self.position.x = _anchor_x
		self.position.y = y_pos

func _physics_process(delta):
	var direction = Vector2.ZERO

	if side == Globals.Side.LEFT:
		if Input.is_action_pressed("up"):
			direction.y -= 1
		if Input.is_action_pressed("down"):
			direction.y += 1
	elif is_ai:
		_ai_offset_timer -= delta
		if _ai_offset_timer <= 0.0:
			_ai_offset = randf_range(-120.0, 120.0)
			_ai_offset_timer = randf_range(0.5, 1.5)

		var target_y = _ball.position.y + _ai_offset
		var diff = target_y - position.y
		var margin = 80.0  # dead zone to prevent jitter
		if diff > margin:
			direction.y = 1
		elif diff < -margin:
			direction.y = -1

	if direction != Vector2.ZERO:
		_current_velocity = direction.normalized() * speed
	else:
		var deceleration: float = (speed / stop_time) * delta
		_current_velocity.y = move_toward(_current_velocity.y, 0.0, deceleration)

	velocity = _current_velocity
	velocity.x = 0
	move_and_slide()
	position.x = _anchor_x

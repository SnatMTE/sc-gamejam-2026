extends CharacterBody2D

@export var side: Globals.Side = Globals.Side.LEFT
@export var is_ai: bool = false
@export var speed: float = 400.0
@export var stop_time: float = 0.1

var padding: int = 20
var _current_velocity := Vector2.ZERO
var _anchor_x: float
var _ball: CharacterBody2D
var _ai_offset: float
var _ai_offset_timer: float

func _ready():
	_anchor_x = position.x
	_ball = get_tree().current_scene.get_node("Ball")

func _physics_process(delta):
	var direction = Vector2.ZERO
	var screen_size = get_viewport_rect().size
	var paddle_height = 100

	if side == Globals.Side.LEFT:
		if Input.is_action_pressed("up") and position.y > padding:
			direction.y -= 1
		if Input.is_action_pressed("down") and position.y < screen_size.y - (paddle_height + padding):
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

func position_paddle():
	var screen_size = get_viewport_rect().size
	var y_pos = (screen_size.y / 2) - 50

	if side == Globals.Side.LEFT:
		_anchor_x = 10
		self.position.x = _anchor_x
		self.position.y = y_pos
	else:
		_anchor_x = screen_size.x - 30
		self.position.x = _anchor_x
		self.position.y = y_pos

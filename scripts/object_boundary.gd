extends RigidBody2D

class_name ObjectBoundary

@onready var shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	var viewport_height = get_viewport_rect().size.x
	shape.shape.size.x = viewport_height
	shape.shape.size.y = 30

func anchor_top() -> void:
	position.y = 0

func anchor_bottom() -> void:
	position.y = get_viewport_rect().size.y + shape.shape.size.y

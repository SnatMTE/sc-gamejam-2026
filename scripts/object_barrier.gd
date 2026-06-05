extends Node2D

class_name ObjectBarrier

@onready var body = $StaticBody2D
@onready var collision_shape = $StaticBody2D/CollisionShape2D
@onready var sprite = $Sprite2D

func _ready() -> void:
	self.set_enabled(false)

func set_enabled(enabled: bool) -> void:
	visible = enabled
	collision_shape.set_deferred("disabled", not enabled)

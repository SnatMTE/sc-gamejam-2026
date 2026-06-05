extends Node

@onready var ball: CharacterBody2D = $Ball
@onready var left_paddle: CharacterBody2D = $LeftPaddle
@onready var right_paddle: CharacterBody2D = $RightPaddle
@onready var left_xp_bar: XPBar = $LeftXP
@onready var right_xp_bar: XPBar = $RightXP
@onready var wall_top: RigidBody2D = $TopWall
@onready var wall_bottom: RigidBody2D = $BottomWall
@onready var upgrade_popup: UpgradePopup = $UpgradePopup

@onready var barriers_left: Array[Node2D] = [
	$ObjectBarrier,
	$ObjectBarrier2,
	$ObjectBarrier3,
]

var left_xp: XP = XP.new()
var right_xp: XP = XP.new()

# Track which upgrades have been applied for each side
var left_upgrades: Dictionary = {}
var right_upgrades: Dictionary = {}

func _ready() -> void:
	ball.connect("out_of_bounds", self._on_ball_out_of_bounds)
	left_xp.init(left_xp_bar)
	right_xp.init(right_xp_bar)

func _on_ball_out_of_bounds(side: Globals.Side) -> void:
	if side == Globals.Side.LEFT:
		if right_xp.award_xp():
			_show_upgrade_popup(Globals.Side.RIGHT)
	elif left_xp.award_xp():
			_show_upgrade_popup(Globals.Side.LEFT)

func _show_upgrade_popup(side: Globals.Side) -> void:
	if side == Globals.Side.LEFT:
		upgrade_popup.setup(side)
		upgrade_popup.visible = true
		get_tree().paused = true

func _on_upgrade_selected(side: Globals.Side, upgrade_name: String) -> void:
	match upgrade_name:
		"barriers":
			_apply_barrier_upgrade(side)

	upgrade_popup.visible = false
	get_tree().paused = false

func _apply_barrier_upgrade(side: Globals.Side) -> void:
	var upgrades: Dictionary = left_upgrades if side == Globals.Side.LEFT else right_upgrades
	if upgrades.get("barriers", false):
		return  # Already applied

	upgrades["barriers"] = true

	if side == Globals.Side.LEFT:
		for barrier in barriers_left:
			barrier.set_enabled(true)

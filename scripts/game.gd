extends Node

const DEFAULT_XP_REWARD = 34
const XP_PER_LEVEL = 100

@onready var ball = $Ball
@onready var left_paddle = $LeftPaddle
@onready var right_paddle = $RightPaddle
@onready var left_xp_bar: XPBar = $LeftXP
@onready var right_xp_bar: XPBar = $RightXP
@onready var upgrade_popup = $UpgradePopup

@onready var barriers_left: Array[Node2D] = [
	$ObjectBarrier,
	$ObjectBarrier2,
	$ObjectBarrier3,
]

var left_xp = 0
var right_xp = 0

var left_level = 1
var right_level = 1

# Track which upgrades have been applied for each side
var left_upgrades: Dictionary = {}
var right_upgrades: Dictionary = {}

func _ready() -> void:
	ball.connect("out_of_bounds", self._on_ball_out_of_bounds)
	left_xp_bar.set_xp(left_xp)
	right_xp_bar.set_xp(right_xp)
	left_xp_bar.set_level(left_level)
	right_xp_bar.set_level(right_level)

func _on_ball_out_of_bounds(side: Globals.Side) -> void:
	if side == Globals.Side.LEFT:
		right_xp += DEFAULT_XP_REWARD
		right_xp_bar.set_xp(right_xp)

		if right_xp >= XP_PER_LEVEL:
			right_level += 1
			right_xp = 0
			right_xp_bar.set_xp(right_xp)
			right_xp_bar.set_level(right_level)
			_show_upgrade_popup(Globals.Side.RIGHT)
	else:
		left_xp += DEFAULT_XP_REWARD
		left_xp_bar.set_xp(left_xp)

		if left_xp >= XP_PER_LEVEL:
			left_level += 1
			left_xp = 0
			left_xp_bar.set_xp(left_xp)
			left_xp_bar.set_level(left_level)
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
	var upgrades = left_upgrades if side == Globals.Side.LEFT else right_upgrades
	if upgrades.get("barriers", false):
		return  # Already applied

	upgrades["barriers"] = true

	if side == Globals.Side.LEFT:
		for barrier in barriers_left:
			barrier.set_enabled(true)

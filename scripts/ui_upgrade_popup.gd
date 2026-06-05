extends Control

class_name UpgradePopup

signal upgrade_selected(side: Globals.Side, upgrade_name: String)

var _side: Globals.Side

func setup(side: Globals.Side) -> void:
	_side = side
	var title_label: Label = %TitleLabel
	if side == Globals.Side.LEFT:
		title_label.text = "LEFT PLAYER LEVEL UP!"
	else:
		title_label.text = "RIGHT PLAYER LEVEL UP!"

func _on_barrier_button_pressed() -> void:
	upgrade_selected.emit(_side, "barriers")

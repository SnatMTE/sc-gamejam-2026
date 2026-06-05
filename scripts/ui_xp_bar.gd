extends Node

class_name XPBar

func set_xp(value: int) -> void:
	$ProgressBar.value = value

func set_level(level: int) -> void:
	$LevelLabel.text = "Lvl %d" % level

class_name XP

const DEFAULT_XP_REWARD: int = 34
const XP_PER_LEVEL: int = 100

var xp_bar: XPBar
var xp: int = 0
var level: int = 1

func init(bar: XPBar) -> void:
	xp_bar = bar
	bar.set_xp(xp)
	bar.set_level(level)

# Awards XP and handles leveling up. Returns true if a level-up occurred.
func award_xp(amount: int = DEFAULT_XP_REWARD) -> bool:
	xp += amount
	xp_bar.set_xp(xp)

	if xp >= XP_PER_LEVEL:
		level += 1
		xp = 0
		xp_bar.set_xp(xp)
		xp_bar.set_level(level)
		return true
	
	return false
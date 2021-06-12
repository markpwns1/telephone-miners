extends VBoxContainer

func select(unit: Node):
	show()
	if unit.get("fstate") != null:
		$move.show()
		$mine.hide()
		$fight.show()
		$defend.show()
	elif unit.get("mstate") != null:
		$move.show()
		$mine.show()
		$fight.hide()
		$defend.hide()
	else:
		$move.hide()
		$mine.show()
		$fight.show()
		$defend.show()

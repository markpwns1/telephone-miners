extends VBoxContainer

func select(unit: Node):
	show()
	$move.show()
	$mine.show()
	$fight.show()
	if unit.get("fstate") != null:
		$mine.hide()
	elif unit.get("mstate") != null:
		$fight.hide()

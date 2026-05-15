class_name EditActionRow
extends ColorRect


func set_action(action: Action) -> void:
	set_name(action.get_name()) # sets name of node
	set_action_name(action.get_name())


func set_action_name(value: String) -> void:
	$Name.text = value


func set_row_location(y: float) -> void:
	var p = get_position()
	p.y = y
	set_position(p)

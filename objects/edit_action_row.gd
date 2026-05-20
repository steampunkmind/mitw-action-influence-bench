class_name EditActionRow
extends ColorRect

var _action: Action

signal delete_action_button_pressed

func set_action(action: Action) -> void:
	_action = action
	set_name(action.get_name()) # sets name of node
	set_action_name(action.get_name())


func set_action_name(value: String) -> void:
	$Name.text = value


func set_row_location(y: float) -> void:
	var p = get_position()
	p.y = y
	set_position(p)


func _on_delete_action_button_pressed() -> void:
	delete_action_button_pressed.emit()

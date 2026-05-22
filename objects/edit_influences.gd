extends Control

var _action: Action


func set_action(action: Action) -> void:
	_action = action
	set_custom_minimum_size($BehaviorCheckBox.get_minimum_size())

class_name EditParams extends VBoxContainer

var _action: Action


func set_action(action: Action) -> void:
	_action = action
	set_custom_minimum_size($BehaviorCheckBox.get_minimum_size())
	$BehaviorCheckBox.set_pressed_no_signal(action.get_behavioral())


func _on_behavior_check_box_toggled(toggled_on: bool) -> void:
	# Have to dirty document here.
	_action.set_behavioral(toggled_on)

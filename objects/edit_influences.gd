class_name EditInfluences extends VBoxContainer

var _action: Action


func set_action(action: Action) -> void:
	_action = action


func _on_add_influence_button_pressed() -> void:
	print("_on_add_influence_button_pressed")

class_name EditActionRow
extends ColorRect

var _action: Action
var edit_influences: Array[Control]

signal delete_action_button_pressed


func set_action(action: Action) -> void:
	_action = action
	set_name(action.get_name()) # sets name of node
	set_action_name(action.get_name())
	$HBox/EditInfluences.set_action(action)
	var p: Vector2 = get_combined_minimum_size()
	p.y = $HBox/EditInfluences.get_combined_minimum_size().y
	set_custom_minimum_size(p)


func set_action_name(value: String) -> void:
	$HBox/Name.text = value


func _on_delete_action_button_pressed() -> void:
	delete_action_button_pressed.emit()


func get_min_name_width() -> float:
	return $HBox/Name.get_minimum_size().x


func set_min_name_width(value: float) -> void:
	var p = $HBox/Name.get_custom_minimum_size()
	p.x = value
	$HBox/Name.set_custom_minimum_size(p)
	

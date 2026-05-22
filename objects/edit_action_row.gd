class_name EditActionRow
extends ColorRect

var _action: Action
var edit_influences: Array[Control]

signal delete_action_button_pressed


func set_action(action: Action) -> void:
	_action = action
	set_name(action.get_name()) # sets name of node
	set_action_name(action.get_name())
	$HBox/ViewParams.text = _param_text()
	$HBox/ViewInfluences.text = _influences_text()
	$HBox/EditInfluences.set_action(action)
	var y = $HBox/ViewInfluences.get_combined_minimum_size().y
	if y < $HBox/EditInfluences.get_combined_minimum_size().y:
		y = $HBox/EditInfluences.get_combined_minimum_size().y
	var p: Vector2 = get_combined_minimum_size()
	p.y = y
	set_custom_minimum_size(p)


func set_action_name(value: String) -> void:
	$HBox/Name.text = value


func _param_text() -> String:
	var text: String = "behavioral: "
	if _action.get_behavioral():
		text += "true\r"
	else:
		text += "false\r"
	return text


func _influences_text() -> String:
	var result: String = ""
	for influence: Influence in _action.get_influences():
		result += influence.to_text() + "\r"
	return result


func _on_delete_action_button_pressed() -> void:
	delete_action_button_pressed.emit()


func get_min_name_width() -> float:
	return $HBox/Name.get_minimum_size().x


func set_min_name_width(value: float) -> void:
	var p = $HBox/Name.get_custom_minimum_size()
	p.x = value
	$HBox/Name.set_custom_minimum_size(p)


func _on_edit_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$HBox/ViewParams.hide()
		$HBox/Spacer.hide()
		$HBox/ViewInfluences.hide()
		$HBox/EditInfluences.show()
	else:
		$HBox/ViewParams.show()
		$HBox/Spacer.show()
		$HBox/ViewInfluences.show()
		$HBox/EditInfluences.hide()

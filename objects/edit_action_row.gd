class_name EditActionRow extends VBoxContainer

var _action: Action
var edit_influences: Array[Control]

const BOTTOM_MARGIN = 6

signal model_edited
signal delete_action_button_pressed


func set_action(action: Action) -> void:
	_action = action
	set_name(action.get_name()) # sets name of node
	set_action_name(action.get_name())
	$HBox/ViewParams.text = _param_text()
	$HBox/EditActionParams.set_action(action)
	$HBox/ViewInfluences.text = _influences_text()
	$HBox/EditInfluences.set_action(action)


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
		$HBox/EditActionParams.show()
		$HBox/ViewInfluences.hide()
		$HBox/EditInfluences.show()
	else:
		$HBox/ViewParams.text = _param_text()
		$HBox/ViewParams.show()
		$HBox/EditActionParams.hide()
		$HBox/ViewInfluences.text = _influences_text()
		$HBox/ViewInfluences.show()
		$HBox/EditInfluences.hide()


func _on_behavior_check_box_toggled(toggled_on: bool) -> void:
	_action.set_behavioral(toggled_on)
	$HBox/ViewParams.text = _param_text()
	model_edited.emit()


func _model_changed() -> void:
	model_edited.emit()

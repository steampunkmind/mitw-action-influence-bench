class_name EditSensorRow extends VBoxContainer

var _sensor: Sensor
var edit_influences: Array[Control]

const BOTTOM_MARGIN = 6

signal model_edited
signal delete_sensor_button_pressed


func set_sensor(sensor: Sensor) -> void:
	_sensor = sensor
	set_name(sensor.get_name()) # sets name of node
	set_sensor_name(sensor.get_name())
	$HBox/ViewParams.text = _param_text()
	$HBox/EditSensorParams.set_sensor(sensor)
	$HBox/ViewInfluences.text = _influences_text()
	#$HBox/EditSensorInfluences.set_sensor(sensor)


func set_sensor_name(value: String) -> void:
	$HBox/Name.text = value


func _param_text() -> String:
	return str(_sensor.get_dict())


func _influences_text() -> String:
	var result: Dictionary = {}
	var sensor_name = _sensor.get_name()
	for action: Action in MITW.aim_model().get_actions():
		for influence: Influence in action.get_influences():
			if influence.get_sensor_name() == sensor_name:
				result.set(action.get_name(), influence.get_dict())
	return str(result)


func _on_delete_sensor_button_pressed() -> void:
	delete_sensor_button_pressed.emit()


func get_min_name_width() -> float:
	return $HBox/Name.get_minimum_size().x


func set_min_name_width(value: float) -> void:
	var p = $HBox/Name.get_custom_minimum_size()
	p.x = value
	$HBox/Name.set_custom_minimum_size(p)


func _on_edit_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$HBox/ViewParams.hide()
		$HBox/EditSensorParams.show()
		$HBox/ViewInfluences.hide()
		$HBox/EditInfluences.show()
	else:
		$HBox/ViewParams.text = _param_text()
		$HBox/ViewParams.show()
		$HBox/EditSensorParams.hide()
		$HBox/ViewInfluences.text = _influences_text()
		$HBox/ViewInfluences.show()
		$HBox/EditInfluences.hide()


func _on_name_text_changed(new_text: String) -> void:
	$HBox/Name.text = new_text
	_sensor.set_name(new_text)
	_model_changed()


func _on_min_value_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		_sensor.set_min(new_text.to_float())
		_model_changed()


func _on_max_value_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		_sensor.set_max(new_text.to_float())
		_model_changed()


func _on_init_value_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		_sensor.set_init(new_text.to_float())
		_sensor.set_value(new_text.to_float())
		_model_changed()


func _model_changed() -> void:
	model_edited.emit()

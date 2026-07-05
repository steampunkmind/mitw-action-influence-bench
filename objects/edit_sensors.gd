class_name EditSensors extends Control

signal model_changed

@export var edit_sensor_row_template: PackedScene

var _edit_sensor_rows: Array[EditSensorRow]


func init():
	clear_edit_sensor_rows()
	_add_edit_sensor_rows()


func clear_edit_sensor_rows() -> void:
	for edit_sensor_row: EditSensorRow in _edit_sensor_rows:
		$SensorScroll/Sensors.remove_child(edit_sensor_row)
	_edit_sensor_rows.clear()


func _add_edit_sensor_rows() -> void:
	for sensor: Sensor in MITW.aim_model().get_sensors():
		var row = edit_sensor_row_template.instantiate()
		row.set_sensor(sensor)
		row.delete_sensor_button_pressed.connect(_delete_sensor_button_pressed.bind(sensor))
		row.model_edited.connect(_model_edited)
		$SensorScroll/Sensors.add_child(row)
		_edit_sensor_rows.append(row)
		
	var min_name_width: float = 0
	for row: EditSensorRow in _edit_sensor_rows:
		var min = row.get_min_name_width()
		if min_name_width < min:
			min_name_width = min
			
	for row: EditSensorRow in _edit_sensor_rows:
		row.set_min_name_width(min_name_width)


func _on_add_button_button_up() -> void:
	MITW.aim_model().new_sensor()
	_model_changed()


func _delete_sensor_button_pressed(sensor: Sensor) -> void:
	MITW.aim_model().delete_sensor(sensor)
	_model_changed()


func _model_changed() -> void:
	clear_edit_sensor_rows()
	_add_edit_sensor_rows()
	model_changed.emit()
	
	
func _model_edited() -> void:
	model_changed.emit()

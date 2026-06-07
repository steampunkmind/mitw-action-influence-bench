class_name EditDictEntry extends Control

var _dict: Dictionary

const INFLOW_PERCENT = "inflow_percent"
const SENSOR_NAME = "sensor_name"

signal model_changed


func init(dict: Dictionary) -> void:
	_dict = dict
	$Value.text = str(dict.get(INFLOW_PERCENT))
	$Sensor.text = dict.get(SENSOR_NAME)
	
	var id = 1
	for sensor: Sensor in MITW.aim_model().get_sensors():
		$Sensor.get_popup().add_item(sensor.get_name(), id)
		id += 1
		
	$Sensor.get_popup().index_pressed.connect(_on_sensor_menu_index_pressed)


func _on_value_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		_dict.set(INFLOW_PERCENT, new_text.to_float())
		model_changed.emit()


func _on_sensor_menu_index_pressed(index) -> void:
	var sensor: Sensor = MITW.aim_model().get_sensors().get(index)
	$Sensor.text = sensor.get_name()
	_dict.set(SENSOR_NAME, sensor.get_name())
	model_changed.emit()


func _new_expression() -> Variant:
	return {}


func _on_delete_button_pressed() -> void:
	print("_on_delete_button_pressed")

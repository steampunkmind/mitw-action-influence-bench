class_name EditDictEntry extends Control

var _dict: Dictionary


func init(dict: Dictionary) -> void:
	_dict = dict
	$Value.text = str(dict.get("inflow_percent"))
	$Sensor.text = dict.get("sensor_name")
	
	var id = 1
	for sensor: Sensor in MITW.aim_model().get_sensors():
		$Sensor.get_popup().add_item(sensor.get_name(), id)
		id += 1

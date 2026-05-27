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
	
	var x = $Value.get_combined_minimum_size().x
	x += $Label.get_combined_minimum_size().x
	x += $Sensor.get_minimum_size().x
	var p = get_combined_minimum_size()
	p.x = x
	set_custom_minimum_size(p)

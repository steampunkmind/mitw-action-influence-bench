class_name EditDictEntry extends Control

var _dict: Dictionary


func init(dict: Dictionary) -> void:
	_dict = dict
	$Value.text = str(dict.get("inflow_percent"))
	$Sensor.text = dict.get("sensor_name")

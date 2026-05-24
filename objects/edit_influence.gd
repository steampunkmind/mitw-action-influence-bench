class_name EditInfluence extends Control

var _influence: Influence


func set_influence(influence: Influence) -> void:
	_influence = influence
	$SensorName.text = influence.get_sensor_name()
	set_custom_minimum_size($SensorName.get_minimum_size())
	
	

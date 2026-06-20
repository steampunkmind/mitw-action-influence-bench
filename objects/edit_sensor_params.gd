class_name EditSensorParams extends HBoxContainer

var _sensor: Sensor


func set_sensor(sensor: Sensor) -> void:
	_sensor = sensor
	$NameValue.text = sensor.get_name()
	$MinValue.text = str(sensor.get_min())
	$MaxValue.text = str(sensor.get_max())
	$InitValue.text = str(sensor.get_init())

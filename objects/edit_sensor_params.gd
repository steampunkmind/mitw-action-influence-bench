class_name EditSensorParams extends VBoxContainer

var _sensor: Sensor


func set_sensor(sensor: Sensor) -> void:
	_sensor = sensor
	$Name.text = sensor.get_name()

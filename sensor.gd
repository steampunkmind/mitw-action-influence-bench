class_name Sensor extends RefCounted

var data: Dictionary

# Constructor
func _init(name: String, min: float, max: float, value: float):
	data.set('name', name)
	data.set('min', min)
	data.set('max', max)
	data.set('value', value)
	
func get_name():
	return data.get('name')

func get_min():
	return data.get('min')

func get_max():
	return data.get('max')

func get_value():
	return data.get('value')
	
func get_data() -> Dictionary:
	return data

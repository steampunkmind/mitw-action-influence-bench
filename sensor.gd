class_name Sensor extends RefCounted

var dict = {}

# Constructor
func _init(name: String, min: float, max: float, value: float):
	dict.set('name', name)
	dict.set('min', min)
	dict.set('max', max)
	dict.set('value', value)
	
func get_name():
	return dict.get('name')

func get_min():
	return dict.get('min')

func get_max():
	return dict.get('max')

func get_value():
	return dict.get('value')
	
func get_dict() -> Dictionary:
	return dict

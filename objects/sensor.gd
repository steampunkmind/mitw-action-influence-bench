class_name Sensor extends RefCounted

var _dict = {}

# Constructor
func _init(name: String, min: float, max: float, value: float):
	_dict.set('name', name)
	_dict.set('min', min)
	_dict.set('max', max)
	_dict.set('value', value)
	
	
func get_name():
	return _dict.get('name')
	
	
func get_min():
	return _dict.get('min')
	
	
func get_max():
	return _dict.get('max')
	
	
func get_value() -> float:
	return _dict.get('value')
	
	
func set_value(value: float):
	_dict.set('value', value)
	
	
func get_dict() -> Dictionary:
	return _dict
	
	

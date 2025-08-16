class_name Influence extends RefCounted

var _signal_name
var _formula

# Constructor
func _init(signal_name: String, formula: Formula):
	_signal_name = signal_name
	_formula = formula
	
	
func get_signal_name():
	return _signal_name
	
	
func get_formula():
	return _formula
	
	
func get_dict() -> Dictionary:
	return _formula.get_dict()
	
	

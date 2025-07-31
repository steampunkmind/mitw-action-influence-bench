class_name Influence extends RefCounted

var _dict = {}
var _formula

# Constructor
func _init(signal_name: String, formula: Formula):
	_dict.set('signal_name', signal_name)
	_formula = formula
	
	
func get_signal_name():
	return _dict.get('signal_name')
	
	
func get_formula():
	return _formula
	
	
func get_dict() -> Dictionary:
	var result = _dict.duplicate(true)
	result.set('formula', _formula.get_dict())
	return result
	
	

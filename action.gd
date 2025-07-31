class_name Action extends RefCounted

var _dict = {}
var _influences: Array[Influence]

# Constructor
func _init(name: String, influences: Array[Influence] = []):
	_dict.set('name', name)
	_influences = influences
	
	
func get_name():
	return _dict.get('name')
	
	
func get_influences():
	return _influences
	
	
func get_dict() -> Dictionary:
	var result = _dict.duplicate(true)
	var influences = []
	for influence: Influence in _influences:
		influences.append(influence.get_dict())
	result.set('influences', influences)
	return result
	
	

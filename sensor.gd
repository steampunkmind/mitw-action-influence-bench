class_name Sensor extends RefCounted

var name: String
var min: float
var max: float
var value: float

# Constructor
func _init(name: String, min: float, max: float, value: float):
	self.name = name
	self.min = min
	self.max = max
	self.value = value
	

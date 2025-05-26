class_name Influence extends RefCounted

var signal_name: String
var formula: Formula

# Constructor
func _init(signal_name: String, formula: Formula):
	self.signal_name = signal_name
	self.formula = formula
	
	

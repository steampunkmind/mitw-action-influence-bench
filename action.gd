class_name Action extends RefCounted

var name: String
var influences: Array[Influence]

# Constructor
func _init(name: String, influences: Array[Influence] = []):
	self.name = name
	self.influences = influences
	
	

class_name EditInfluence extends Control

var _influence: Influence
var _edit_expressions: Array[EditExpression]

@export var edit_expression_template: PackedScene


func set_influence(influence: Influence) -> void:
	_influence = influence
	
	$SensorName.text = influence.get_sensor_name()
	
	var y = $SensorName.get_minimum_size().y
	var expressions: Dictionary = influence.get_formula().get_expressions()
	for key: String in expressions.keys():
		var row: EditExpression = edit_expression_template.instantiate()
		row.set_expression_type(key)
		add_child(row)
		y += row.get_minimum_size().y
		
	var size = $SensorName.get_minimum_size()
	size.y = y
	set_custom_minimum_size(size)

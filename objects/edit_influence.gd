class_name EditInfluence extends Control

var _influence: Influence
var _edit_expressions: Array[EditExpression]

@export var edit_expression_template: PackedScene


func set_influence(influence: Influence) -> void:
	_influence = influence
	$SensorName.text = influence.get_sensor_name()
	var expressions: Dictionary = influence.get_formula().get_expressions()
	for key: String in expressions.keys():
		var expression: EditExpression = edit_expression_template.instantiate()
		expression.set_expression_type(key)
		$VBox.add_child(expression)
		_edit_expressions
	
	_set_minimum_y()


func _set_minimum_y() -> void:
	var y: float = $SensorName.get_combined_minimum_size().y
	for expression: EditExpression in _edit_expressions:
		y += expression.get_combined_minimum_size().y
	
	var p: Vector2 = get_combined_minimum_size()
	p.y = y + 100 #TEMP
	set_custom_minimum_size(p)

class_name EditInfluence extends Control

var _influence: Influence
var _edit_expressions: Array[EditExpression]

@export var edit_default_expression_template: PackedScene
@export var edit_linear_expression_template: PackedScene


func set_influence(influence: Influence) -> void:
	_influence = influence
	$SensorName.text = influence.get_sensor_name()
	var expressions: Dictionary = influence.get_formula().get_expressions()
	for key: String in expressions.keys():
		var expression: EditExpression = _expression_by_type(key, expressions)
		$VBox.add_child(expression)
		_edit_expressions.append(expression)
		
	_set_minimum_y()


func _set_minimum_y() -> void:
	var p: Vector2 = get_combined_minimum_size()
	p.y += $SensorName.get_combined_minimum_size().y
	for expression: EditExpression in _edit_expressions:
		p.y += expression.get_combined_minimum_size().y
	set_custom_minimum_size(p)


func _expression_by_type(type: String, expressions: Dictionary) -> EditExpression:
	var result: EditExpression
	match type:
		SensorFormulaLinear.TYPE:
			result = edit_linear_expression_template.instantiate()
		_:
			result = edit_default_expression_template.instantiate()
	
	result.init(type, expressions)
	return result

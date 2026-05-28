class_name EditInfluence extends Control

var _influence: Influence
var _edit_expressions: Array[EditExpression]

signal model_changed

@export var edit_default_expression_template: PackedScene
@export var edit_single_value_expression_template: PackedScene
@export var edit_percent_inflow_expression_template: PackedScene
@export var edit_max_limit_expression_template: PackedScene
@export var edit_outflow_percent_expression_template: PackedScene


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
			result = edit_single_value_expression_template.instantiate()
		SensorFormulaInflowPercent.TYPE:
			result = edit_percent_inflow_expression_template.instantiate()
		SensorFormulaMaxLimit.TYPE:
			result = edit_max_limit_expression_template.instantiate()
		SensorFormulaOutflowPercent.TYPE:
			result = edit_single_value_expression_template.instantiate()
			result.show_percent()
		_:
			result = edit_default_expression_template.instantiate()
	
	result.init(type, expressions)
	result.model_changed.connect(_model_changed)
	return result


func _model_changed() -> void:
	model_changed.emit()

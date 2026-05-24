class_name EditExpression extends Control

var _expression_type: Dictionary


func set_expression_type(_expression_type: String) -> void:
	$ExpressionType.text = _expression_type
	set_custom_minimum_size($ExpressionType.get_minimum_size())

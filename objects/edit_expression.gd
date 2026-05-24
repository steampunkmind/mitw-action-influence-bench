class_name EditExpression extends Control

var _expression_type: String
var _expression


func set_expression_type(expression_type: String, expression) -> void:
	_expression_type = expression_type
	_expression = expression
	$ExpressionType.text = expression_type
	$Expression.text = str(expression)

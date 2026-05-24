class_name EditExpression extends Control

var _expression_type: String
var _expressions


func set_expression_type(expression_type: String, expressions) -> void:
	_expression_type = expression_type
	_expressions = expressions
	$VBox/ExpressionType.text = expression_type
	$VBox/Expressions.text = str(expressions)
	_set_minimum_y()


func _set_minimum_y() -> void:
	var p: Vector2 = get_combined_minimum_size()
	p.y += $VBox/ExpressionType.get_combined_minimum_size().y
	p.y += $VBox/Expressions.get_combined_minimum_size().y
	set_custom_minimum_size(p)

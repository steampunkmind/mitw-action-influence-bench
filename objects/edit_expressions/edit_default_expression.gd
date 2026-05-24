class_name EditDefaultExpression extends EditExpression


func init(expression_type: String, expression) -> void:
	super.init(expression_type, expression)
	$ExpressionType.text = expression_type
	$Expression.text = str(expression)

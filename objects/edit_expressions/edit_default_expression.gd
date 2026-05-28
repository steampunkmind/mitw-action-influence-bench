class_name EditDefaultExpression extends EditExpression


func init(key: String, expressions: Dictionary) -> void:
	super.init(key, expressions)
	$ExpressionType.text = key
	$Expression.text = str(expression())

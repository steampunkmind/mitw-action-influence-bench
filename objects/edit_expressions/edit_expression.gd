class_name EditExpression extends Control

var _key: String
var _expressions: Dictionary

signal model_changed


func init(key: String, expressions: Dictionary) -> void:
	_key = key
	_expressions = expressions


func expression() -> Variant:
	var result = _expressions.get(_key)
	if result == null:
		result = new_expression()
	return result


func new_expression() -> Variant: 
	print("Override new_expression in EditExpression")
	return null

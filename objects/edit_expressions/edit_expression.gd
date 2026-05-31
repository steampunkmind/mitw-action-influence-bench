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
		result = _new_expression()
		_expressions.set(_key, result)
	return result


func _new_expression() -> Variant:
	print("Override _new_expression in EditExpression")
	return null

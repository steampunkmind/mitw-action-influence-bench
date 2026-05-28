class_name EditExpression extends Control

var _key: String
var _expressions: Dictionary

signal model_changed


func init(key: String, expressions: Dictionary) -> void:
	_key = key
	_expressions = expressions


func expression():
	return _expressions.get(_key)

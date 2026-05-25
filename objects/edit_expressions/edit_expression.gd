class_name EditExpression extends Control

var _key: String
var _expressions: Dictionary


func init(key: String, expressions: Dictionary) -> void:
	_key = key
	_expressions = expressions

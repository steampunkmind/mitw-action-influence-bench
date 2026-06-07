class_name EditActionMinMaxExpression extends EditExpression


func init(key: String, expressions) -> void:
	super.init(key, expressions)
	$Name.text = key + ": "
	$MinValue.text = str(expression())
	$MaxValue.text = str(expression())


func _on_min_value_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		_expressions.set(_key, new_text.to_float())
		model_changed.emit()


func _on_max_value_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		_expressions.set(_key, new_text.to_float())
		model_changed.emit()


func new_expression() -> Variant:
	return {"min_delay": 60, "max_delay": 120, "action": DEFAULT_SELECTION}

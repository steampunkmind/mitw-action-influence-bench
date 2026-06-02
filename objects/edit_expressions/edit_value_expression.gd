class_name EditValueExpression extends EditExpression


func init(key: String, expressions) -> void:
	super.init(key, expressions)
	$Name.text = key + ": "
	$Value.text = str(expression())


func _on_value_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		_expressions.set(_key, new_text.to_float())
		model_changed.emit()


func show_percent() -> void:
	$Percent.visible = true


func new_expression() -> Variant:
	return 0.0

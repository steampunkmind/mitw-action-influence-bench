class_name EditInflowPercentExpression extends EditExpression


func init(key: String, expressions) -> void:
	super.init(key, expressions)
	$Value.text = str(expressions.get(key))


func _on_text_edit_text_changed() -> void:
	var text: String = $Value.get_text()
	if text.is_valid_float():
		_expressions.set(_key, text.to_float())
		model_changed.emit()

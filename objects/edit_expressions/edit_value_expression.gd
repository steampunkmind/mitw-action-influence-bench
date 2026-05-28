class_name EditValueExpression extends EditExpression


func init(key: String, expressions) -> void:
	super.init(key, expressions)
	$Name.text = key + ": "
	$Value.text = str(expression())


func _on_text_edit_text_changed() -> void:
	var text: String = $Value.get_text()
	if text.is_valid_float():
		_expressions.set(_key, text.to_float())
		model_changed.emit()


func show_percent() -> void:
	$Percent.visible = true

class_name EditLinearExpression extends EditExpression


func init(expression_type: String, expression) -> void:
	super.init(expression_type, expression)
	$Value.text = str(expression)


func _on_text_edit_text_changed() -> void:
	print("_on_text_edit_text_changed")

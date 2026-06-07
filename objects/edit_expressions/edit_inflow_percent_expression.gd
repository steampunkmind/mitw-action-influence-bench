class_name EditInflowPercentExpression extends EditExpression

@export var edit_dict_entry_template: PackedScene


func init(key: String, expressions) -> void:
	super.init(key, expressions)
	var expression_index = 0
	for dict: Dictionary in expression():
		var edit_dict_entry: EditDictEntry = edit_dict_entry_template.instantiate()
		edit_dict_entry.init(dict)
		edit_dict_entry.model_changed.connect(_model_changed)
		edit_dict_entry.delete_edit_dict_entry.connect(_delete_edit_dict_entry.bind(edit_dict_entry, expression_index))	
		$HFlow.add_child(edit_dict_entry)
		expression_index += 1


func new_expression() -> Variant:
	return [EditDictEntry.new_sub_expression()]


func _on_add_button_pressed() -> void:
	var expression: Array = expression()
	var expression_index = expression.size()
	var sub_expression = EditDictEntry.new_sub_expression()
	expression.append(sub_expression)
	
	var edit_dict_entry: EditDictEntry = edit_dict_entry_template.instantiate()
	edit_dict_entry.init(sub_expression)
	edit_dict_entry.model_changed.connect(_model_changed)
	edit_dict_entry.delete_edit_dict_entry.connect(_delete_edit_dict_entry.bind(edit_dict_entry, expression_index))	
	$HFlow.add_child(edit_dict_entry)

	_model_changed()


func _delete_edit_dict_entry(edit_dict_entry, expression_index) -> void:
	$HFlow.remove_child(edit_dict_entry)
	expression().remove_at(expression_index)
	_model_changed()


func _model_changed() -> void:
	model_changed.emit()

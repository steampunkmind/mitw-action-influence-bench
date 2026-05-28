class_name EditInflowPercentExpression extends EditExpression

@export var edit_dict_entry_template: PackedScene


func init(key: String, expressions) -> void:
	super.init(key, expressions)
	for dict: Dictionary in expression():
		var edit_dict_entry: EditDictEntry = edit_dict_entry_template.instantiate()
		edit_dict_entry.init(dict)
		edit_dict_entry.model_changed.connect(_model_changed)
		$HFlow.add_child(edit_dict_entry)


func _model_changed() -> void:
	model_changed.emit()

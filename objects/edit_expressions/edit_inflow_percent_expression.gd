class_name EditInflowPercentExpression extends EditExpression

@export var edit_dict_entry_template: PackedScene


func init(key: String, expressions) -> void:
	super.init(key, expressions)
	var expression = expressions.get(key)
	var x: float = $Name.size.x + 12
	for dict: Dictionary in expression:
		var edit_dict_entry = edit_dict_entry_template.instantiate()
		edit_dict_entry.init(dict)
		add_child(edit_dict_entry)
		
		var p = edit_dict_entry.position
		p.x = x
		edit_dict_entry.set_position(p)
		x += edit_dict_entry.size.x + 20


func _on_text_edit_text_changed() -> void:
	var text: String = $Value.get_text()
	if text.is_valid_float():
		_expressions.set(_key, text.to_float())
		model_changed.emit()

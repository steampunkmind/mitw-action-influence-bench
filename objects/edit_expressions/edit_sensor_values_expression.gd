class_name EditSensorValuesExpression extends EditExpression

@export var edit_sensor_value_template: PackedScene


func init(key: String, expressions) -> void:
	super.init(key, expressions)
	var expression_index = 0
	for expression: Dictionary in expression():
		var edit_sensor_value: EditSensorValue = edit_sensor_value_template.instantiate()
		edit_sensor_value.init(expression)
		edit_sensor_value.model_changed.connect(_model_changed)
		edit_sensor_value.delete_edit_sensor_value.connect(_delete_edit_sensor_value.bind(edit_sensor_value, expression_index))	
		$HFlow.add_child(edit_sensor_value)
		expression_index += 1


func new_expression() -> Variant:
	return [EditSensorValue.new_subexpression()]


func _on_add_button_pressed() -> void:
	var expression: Array = expression()
	var expression_index = expression.size()
	var subexpression = EditSensorValue.new_subexpression()
	expression.append(subexpression)
	
	var edit_sensor_value: EditSensorValue = edit_sensor_value_template.instantiate()
	edit_sensor_value.init(subexpression)
	edit_sensor_value.model_changed.connect(_model_changed)
	edit_sensor_value.delete_edit_sensor_value.connect(_delete_edit_sensor_value.bind(edit_sensor_value, expression_index))	
	$HFlow.add_child(edit_sensor_value)

	_model_changed()


func _delete_edit_sensor_value(edit_sensor_value, expression_index) -> void:
	$HFlow.remove_child(edit_sensor_value)
	expression().remove_at(expression_index)
	_model_changed()


func _model_changed() -> void:
	model_changed.emit()

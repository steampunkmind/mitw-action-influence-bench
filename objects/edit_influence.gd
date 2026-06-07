class_name EditInfluence extends VBoxContainer

var _influence: Influence
var _edit_expressions: Array[EditExpression]

signal model_changed
signal delete_influence

@export var edit_default_expression_template: PackedScene
@export var edit_value_expression_template: PackedScene
@export var edit_sensors_expression_template: PackedScene
@export var edit_inflow_percent_exception: PackedScene


func set_influence(influence: Influence) -> void:
	_influence = influence
	$SensorBox/SensorName.text = influence.get_sensor_name()
	$SensorBox/AddEditExpression.get_popup().index_pressed.connect(_on_add_edit_expression_index_pressed)
	for expression_name: String in MITW.get_sensor_formula_types().keys():
		$SensorBox/AddEditExpression.get_popup().add_item(expression_name)
		
	var expressions: Dictionary = influence.get_formula().get_expressions()
	for key: String in expressions.keys():
		var edit_expression: EditExpression = _expression_by_type(key)
		edit_expression.init(key,expressions)
		$ExpressionBox/Expressions.add_child(edit_expression)
		_edit_expressions.append(edit_expression)


func _expression_by_type(type: String) -> EditExpression:
	var result: EditExpression
	match type:
		SensorFormulaLinear.TYPE:
			result = edit_value_expression_template.instantiate()
		SensorFormulaOutflowPercent.TYPE:
			result = edit_value_expression_template.instantiate()
			result.show_percent()
		SensorFormulaMaxLimit.TYPE, SensorFormulaSum.TYPE:
			result = edit_sensors_expression_template.instantiate()
		SensorFormulaInflowPercent.TYPE:
			result = edit_inflow_percent_exception.instantiate()
		_:
			result = edit_default_expression_template.instantiate()
	
	result.model_changed.connect(_model_changed)
	result.delete_edit_expression.connect(_delete_edit_expression.bind(result))
	return result


func _on_add_edit_expression_index_pressed(index) -> void:
	var expressions: Dictionary = _influence.get_formula().get_expressions()
	var expression_name = $SensorBox/AddEditExpression.get_popup().get_item_text(index)
	var edit_expression: EditExpression = _expression_by_type(expression_name)
	expressions.set(expression_name, edit_expression.new_expression())
	edit_expression.init(expression_name, expressions)
	
	$ExpressionBox/Expressions.add_child(edit_expression)
	_edit_expressions.append(edit_expression)
	_model_changed()


func _delete_edit_expression(edit_expression: EditExpression) -> void:
	$ExpressionBox/Expressions.remove_child(edit_expression)
	_model_changed()


func _on_delete_influence_button_pressed() -> void:
	delete_influence.emit()


func _model_changed() -> void:
	model_changed.emit()

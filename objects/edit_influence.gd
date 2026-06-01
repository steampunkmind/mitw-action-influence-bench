class_name EditInfluence extends VBoxContainer

var _influence: Influence
var _edit_expressions: Array[EditExpression]

signal model_changed
signal delete_influence

@export var edit_default_expression_template: PackedScene
@export var edit_value_expression_template: PackedScene
@export var edit_sensors_expression_template: PackedScene
@export var edit_percent_inflow_expression_template: PackedScene


func set_influence(influence: Influence) -> void:
	_influence = influence
	$HBox/SensorName.text = influence.get_sensor_name()
	$HBox/AddEditExpression.get_popup().index_pressed.connect(_on_add_edit_expression_index_pressed)
	for expression_name: String in MITW.get_sensor_formula_types().keys():
		$HBox/AddEditExpression.get_popup().add_item(expression_name)
		
	var expressions: Dictionary = influence.get_formula().get_expressions()
	for key: String in expressions.keys():
		var expression: EditExpression = _expression_by_type(key, expressions)
		$VBox.add_child(expression)
		_edit_expressions.append(expression)


func _expression_by_type(type: String, expressions: Dictionary) -> EditExpression:
	var result: EditExpression
	match type:
		SensorFormulaLinear.TYPE:
			result = edit_value_expression_template.instantiate()
		SensorFormulaInflowPercent.TYPE:
			result = edit_percent_inflow_expression_template.instantiate()
		SensorFormulaMaxLimit.TYPE:
			result = edit_sensors_expression_template.instantiate()
		SensorFormulaOutflowPercent.TYPE:
			result = edit_value_expression_template.instantiate()
			result.show_percent()
		SensorFormulaSum.TYPE:
			result = edit_sensors_expression_template.instantiate()
		_:
			result = edit_default_expression_template.instantiate()
	
	result.init(type, expressions)
	result.model_changed.connect(_model_changed)
	return result


func _on_add_edit_expression_index_pressed(index) -> void:
	var expression_name = $HBox/AddEditExpression.get_popup().get_item_text(index)
	var expressions: Dictionary = _influence.get_formula().get_expressions()
	expressions.set(expression_name, "-") # get default expression by type
	var expression: EditExpression = _expression_by_type(expression_name, {})
	$VBox.add_child(expression)
	_edit_expressions.append(expression)
	_model_changed()


func _on_delete_influence_button_pressed() -> void:
	delete_influence.emit()


func _model_changed() -> void:
	model_changed.emit()

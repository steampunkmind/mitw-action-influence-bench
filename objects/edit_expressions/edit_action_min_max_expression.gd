class_name EditActionMinMaxExpression extends EditExpression

const MIN_VALUE_KEY = "min_delay"
const MAX_VALUE_KEY = "max_delay"
const ACTION_KEY = "action"


func init(key: String, expressions) -> void:
	super.init(key, expressions)
	var expression: Dictionary = expression()
	$Name.text = key + ": "
	$MinValue.text = str(expression.get(MIN_VALUE_KEY))
	$MaxValue.text = str(expression.get(MAX_VALUE_KEY))
	$ActionMenu.text = expression.get(ACTION_KEY)
	
	var id = 1
	for action: Action in MITW.aim_model().get_actions():
		$ActionMenu.get_popup().add_item(action.get_name(), id)
		id += 1
		
	$ActionMenu.get_popup().index_pressed.connect(_on_action_menu_index_pressed)


func _on_min_value_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		expression().set(MIN_VALUE_KEY, new_text.to_float())
		model_changed.emit()


func _on_max_value_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		expression().set(MAX_VALUE_KEY, new_text.to_float())
		model_changed.emit()


func _on_action_menu_index_pressed(index) -> void:
	var action: Action = MITW.aim_model().get_actions().get(index)
	$ActionMenu.text = action.get_name()
	expression().set(ACTION_KEY, action.get_name())
	model_changed.emit()


func new_expression() -> Variant:
	return {"min_delay": 60, "max_delay": 120, "action": DEFAULT_SELECTION}

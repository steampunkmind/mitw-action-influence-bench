class_name EditActionsMinMaxExpression extends EditExpression

const MIN_VALUE_KEY = "min_delay"
const MAX_VALUE_KEY = "max_delay"
const ACTIONS_KEY = "actions"


func init(key: String, expressions) -> void:
	super.init(key, expressions)
	var expression: Dictionary = expression()
	$Name.text = key + ": "
	$HFlow/MinValue.text = str(expression.get(MIN_VALUE_KEY))
	$HFlow/MaxValue.text = str(expression.get(MAX_VALUE_KEY))
	
	for action: Action in MITW.aim_model().get_actions():
		$HFlow/ActionMenuTemplate.get_popup().add_item(action.get_name())
	
	var expression_index = 0
	for action_name: String in expression.get(ACTIONS_KEY):
		var action_menu = $HFlow/ActionMenuTemplate.duplicate()
		action_menu.get_popup().index_pressed.connect(_on_action_menu_index_pressed.bind(action_menu, expression_index))
		action_menu.text = action_name
		action_menu.set_visible(true)
		$HFlow.add_child(action_menu)
		$HFlow.move_child(action_menu, -5)
		
		var delete_action_button = $HFlow/DeleteActionButtonTemplate.duplicate()
		delete_action_button.pressed.connect(_on_delete_action_button_pressed.bind(delete_action_button, action_menu, expression_index))
		delete_action_button.set_visible(true)
		$HFlow.add_child(delete_action_button)
		$HFlow.move_child(delete_action_button, -5)
		
		expression_index += 1


func _on_action_menu_index_pressed(index, action_menu, expression_index) -> void:
	var action_name = action_menu.get_popup().get_item_text(index)
	action_menu.text = action_name
	expression().get(ACTIONS_KEY).set(expression_index, action_name)
	model_changed.emit()


func _on_min_value_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		expression().set(MIN_VALUE_KEY, new_text.to_float())
		model_changed.emit()


func _on_max_value_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		expression().set(MAX_VALUE_KEY, new_text.to_float())
		model_changed.emit()


func new_expression() -> Variant:
	return {"min_delay": 60, "max_delay": 120, "actions": [DEFAULT_SELECTION,DEFAULT_SELECTION]}


func _on_add_action_button_pressed() -> void:
	var expression: Array = expression().get(ACTIONS_KEY)
	var expression_index = expression.size()
	expression.append(DEFAULT_SELECTION)
	
	var action_menu = $HFlow/ActionMenuTemplate.duplicate()
	action_menu.get_popup().index_pressed.connect(_on_action_menu_index_pressed.bind(action_menu, expression_index))
	action_menu.text = DEFAULT_SELECTION
	action_menu.set_visible(true)
	$HFlow.add_child(action_menu)
	$HFlow.move_child(action_menu, -5)
	
	var delete_action_button = $HFlow/DeleteActionButtonTemplate.duplicate()
	delete_action_button.pressed.connect(_on_delete_action_button_pressed.bind(delete_action_button, action_menu, expression_index))
	delete_action_button.set_visible(true)
	$HFlow.add_child(delete_action_button)
	$HFlow.move_child(delete_action_button, -5)


func _on_delete_action_button_pressed(delete_action_button, action_menu, expression_index) -> void:
	$HFlow.remove_child(delete_action_button)
	$HFlow.remove_child(action_menu)
	expression().remove_at(expression_index)
	model_changed.emit()

class_name EditSensorsExpression extends EditExpression

@export var edit_dict_entry_template: PackedScene


func init(key: String, expressions) -> void:
	super.init(key, expressions)
	$Name.text = key + ": "
	for sensor: Sensor in MITW.aim_model().get_sensors():
		$HFlow/SensorMenuTemplate.get_popup().add_item(sensor.get_name())
		
	var expression_index = 0
	for sensor_name: String in expression():
		var sensor_menu = $HFlow/SensorMenuTemplate.duplicate(DuplicateFlags.DUPLICATE_SIGNALS)
		sensor_menu.get_popup().index_pressed.connect(_on_sensor_menu_index_pressed.bind(sensor_menu, expression_index))
		sensor_menu.text = sensor_name
		sensor_menu.set_visible(true)
		$HFlow.add_child(sensor_menu)
		
		var delete_sensor_button = $HFlow/DeleteSensorButtonTemplate.duplicate()
		delete_sensor_button.pressed.connect(_on_delete_sensor_button_pressed.bind(delete_sensor_button, sensor_menu, expression_index))
		delete_sensor_button.set_visible(true)
		$HFlow.add_child(delete_sensor_button)
		
		expression_index += 1


func _on_sensor_menu_index_pressed(index, sensor_menu, expression_index) -> void:
	var sensor_name = sensor_menu.get_popup().get_item_text(index)
	sensor_menu.text = sensor_name
	expression().set(expression_index, sensor_name)
	model_changed.emit()


func new_expression() -> Variant:
	return ["---"]


func _on_add_sensor_button_pressed() -> void:
	var expression: Array = expression()
	var expression_index = expression.size()
	expression.append(DEFAULT_SELECTION)
	
	var sensor_menu = $HFlow/SensorMenuTemplate.duplicate()
	sensor_menu.get_popup().index_pressed.connect(_on_sensor_menu_index_pressed.bind(sensor_menu, expression_index))
	sensor_menu.text = DEFAULT_SELECTION
	sensor_menu.set_visible(true)
	$HFlow.add_child(sensor_menu)
	
	var delete_sensor_button = $HFlow/DeleteSensorButtonTemplate.duplicate()
	delete_sensor_button.pressed.connect(_on_delete_sensor_button_pressed.bind(delete_sensor_button, sensor_menu, expression_index))
	delete_sensor_button.set_visible(true)
	$HFlow.add_child(delete_sensor_button)


func _on_delete_sensor_button_pressed(delete_sensor_button, sensor_menu, expression_index) -> void:
	$HFlow.remove_child(delete_sensor_button)
	$HFlow.remove_child(sensor_menu)
	expression().remove_at(expression_index)
	model_changed.emit()

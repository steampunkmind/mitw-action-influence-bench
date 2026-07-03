class_name EditSensorInfluences extends VBoxContainer

var _sensor: Sensor

signal model_changed

@export var edit_sensor_influence_template: PackedScene

var _edit_sensor_influences: Array[EditSensorInfluence]

func set_sensor(sensor: Sensor) -> void:
	_sensor = sensor
	$AddEditSensorInfluence.get_popup().index_pressed.connect(_on_add_edit_sensor_influence_index_pressed)
	for action: Action in MITW.aim_model().get_actions():
		$AddEditSensorInfluence.get_popup().add_item(action.get_name())
	_add_edit_sensor_influences()


func _add_edit_sensor_influences() -> void:
	for action: Action in MITW.aim_model().get_actions():
		for influence: Influence in action.get_influences():
			if influence.get_sensor_name() == _sensor.get_name():
				var edit_sensor_influence: EditSensorInfluence = edit_sensor_influence_template.instantiate()
				edit_sensor_influence.set_influence(action, influence)
				edit_sensor_influence.model_changed.connect(_model_changed)
				edit_sensor_influence.delete_influence.connect(_delete_influence.bind(influence))
				add_child(edit_sensor_influence)
				_edit_sensor_influences.append(edit_sensor_influence)


func _clear_edit_sensor_influences() -> void:
	for edit_sensor_influence: EditSensorInfluence in _edit_sensor_influences:
		remove_child(edit_sensor_influence)
	_edit_sensor_influences.clear()


func _on_add_edit_sensor_influence_index_pressed(index) -> void:
	var action = MITW.aim_model().get_action($AddEditSensorInfluence.get_popup().get_item_text(index))
	var influence = action.add_influence(_sensor.get_name())
	var edit_sensor_influence: EditSensorInfluence = edit_sensor_influence_template.instantiate()
	edit_sensor_influence.set_influence(action, influence)
	edit_sensor_influence.model_changed.connect(_model_changed)
	add_child(edit_sensor_influence)
	_edit_sensor_influences.append(edit_sensor_influence)
	_model_changed()


func _delete_influence(influence) -> void:
	print("_delete_influence: " + str(influence))
	#_sensor.delete_influence(influence)
	#_clear_edit_sensor_influences()
	#_add_edit_sensor_influences()
	#_model_changed()


func _model_changed() -> void:
	model_changed.emit()

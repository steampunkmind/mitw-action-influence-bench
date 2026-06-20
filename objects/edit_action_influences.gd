class_name EditActionInfluences extends VBoxContainer

var _action: Action

signal model_changed

@export var edit_action_influence_template: PackedScene

var _edit_action_influences: Array[EditActionInfluence]

func set_action(action: Action) -> void:
	_action = action
	$AddEditActionInfluence.get_popup().index_pressed.connect(_on_add_edit_action_influence_index_pressed)
	for sensor: Sensor in MITW.aim_model().get_sensors():
		$AddEditActionInfluence.get_popup().add_item(sensor.get_name())
	_add_edit_action_influences()


func _add_edit_action_influences() -> void:
	for influence: Influence in _action.get_influences():
		var edit_action_influence: EditActionInfluence = edit_action_influence_template.instantiate()
		edit_action_influence.set_influence(influence)
		edit_action_influence.model_changed.connect(_model_changed)
		edit_action_influence.delete_influence.connect(_delete_influence.bind(influence))
		add_child(edit_action_influence)
		_edit_action_influences.append(edit_action_influence)


func _clear_edit_action_influences() -> void:
	for edit_action_influence: EditActionInfluence in _edit_action_influences:
		remove_child(edit_action_influence)
	_edit_action_influences.clear()


func _on_add_edit_action_influence_index_pressed(index) -> void:
	var sensor_name = $AddEditActionInfluence.get_popup().get_item_text(index)
	var influence = _action.add_influence(sensor_name)
	var edit_action_influence: EditActionInfluence = edit_action_influence_template.instantiate()
	edit_action_influence.set_influence(influence)
	edit_action_influence.model_changed.connect(_model_changed)
	add_child(edit_action_influence)
	_edit_action_influences.append(edit_action_influence)
	_model_changed()


func _delete_influence(influence) -> void:
	_action.delete_influence(influence)
	_clear_edit_action_influences()
	_add_edit_action_influences()
	_model_changed()


func _model_changed() -> void:
	model_changed.emit()

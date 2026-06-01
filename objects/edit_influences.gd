class_name EditInfluences extends VBoxContainer

var _action: Action

signal model_changed

@export var edit_influence_template: PackedScene

var _edit_influences: Array[EditInfluence]

func set_action(action: Action) -> void:
	_action = action
	$AddEditInfluence.get_popup().index_pressed.connect(_on_add_edit_influence_index_pressed)
	for sensor: Sensor in MITW.aim_model().get_sensors():
		$AddEditInfluence.get_popup().add_item(sensor.get_name())
	_add_edit_influences()


func _add_edit_influences() -> void:
	for influence: Influence in _action.get_influences():
		var edit_influence: EditInfluence = edit_influence_template.instantiate()
		edit_influence.set_influence(influence)
		edit_influence.model_changed.connect(_model_changed)
		edit_influence.delete_influence.connect(_delete_influence.bind(influence))
		add_child(edit_influence)
		_edit_influences.append(edit_influence)


func _clear_edit_influences() -> void:
	for edit_influence: EditInfluence in _edit_influences:
		remove_child(edit_influence)
	_edit_influences.clear()


func _on_add_edit_influence_index_pressed(index) -> void:
	var sensor_name = $AddEditInfluence.get_popup().get_item_text(index)
	var influence = _action.add_influence(sensor_name)
	var edit_influence: EditInfluence = edit_influence_template.instantiate()
	edit_influence.set_influence(influence)
	edit_influence.model_changed.connect(_model_changed)
	add_child(edit_influence)
	_edit_influences.append(edit_influence)
	_model_changed()


func _delete_influence(influence) -> void:
	_action.delete_influence(influence)
	_clear_edit_influences()
	_add_edit_influences()
	_model_changed()


func _model_changed() -> void:
	model_changed.emit()

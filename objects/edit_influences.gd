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
		
	for influence: Influence in action.get_influences():
		var edit_influence: EditInfluence = edit_influence_template.instantiate()
		edit_influence.set_influence(influence)
		edit_influence.model_changed.connect(_model_changed)
		add_child(edit_influence)
		_edit_influences.append(edit_influence)
		
	_set_minimum_y()


func _set_minimum_y() -> void:
	var y: float = 0.0
	for edit_influence: EditInfluence in _edit_influences:
		y += edit_influence.get_combined_minimum_size().y
	var p: Vector2 = get_combined_minimum_size()
	p.y = y
	set_custom_minimum_size(p)


func _on_add_edit_influence_index_pressed(index) -> void:
	var sensor_name = $AddEditInfluence.get_popup().get_item_text(index)
	var influence = _action.add_influence(sensor_name)
	var edit_influence: EditInfluence = edit_influence_template.instantiate()
	edit_influence.set_influence(influence)
	edit_influence.model_changed.connect(_model_changed)
	add_child(edit_influence)
	_edit_influences.append(edit_influence)
	_set_minimum_y()
	_model_changed()


func _model_changed() -> void:
	model_changed.emit()

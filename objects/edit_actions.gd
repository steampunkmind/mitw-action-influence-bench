class_name EditActions
extends Control

signal model_changed


@export var edit_action_row_template: PackedScene

var actions:
	get = get_actions, set = set_actions
var _edit_action_rows: Array[EditActionRow]


func get_actions() -> Array[Action]:
	return actions


func set_actions(value: Array[Action]):
	actions = value
	clear_edit_action_rows()
	add_edit_action_rows()


func clear_edit_action_rows() -> void:
	for edit_action_row: EditActionRow in _edit_action_rows:
		$ActionScroll/Actions.remove_child(edit_action_row)
	_edit_action_rows.clear()


func add_edit_action_rows() -> void:
	for action: Action in actions:
		var row = edit_action_row_template.instantiate()
		row.set_action(action)
		row.delete_action_button_pressed.connect(_delete_action_button_pressed.bind(action))
		$ActionScroll/Actions.add_child(row)
		_edit_action_rows.append(row)


func _on_add_button_button_up() -> void:
	var action = Action.new("Action " + str(actions.size() + 1), true)
	actions.append(action)
	_model_changed()


func _delete_action_button_pressed(action: Action) -> void:
	actions.erase(action)
	_model_changed()


func _model_changed() -> void:
	clear_edit_action_rows()
	add_edit_action_rows()
	model_changed.emit()

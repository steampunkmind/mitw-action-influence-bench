class_name EditActions
extends ColorRect

signal model_changed

@export var edit_action_row_template: PackedScene

var actions:
	get = get_actions, set = set_actions
var _edit_action_rows: Array[EditActionRow]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_actions() -> Array[Action]:
	return actions


func set_actions(value: Array[Action]):
	actions = value
	clear_edit_action_rows()
	add_edit_action_rows()


func clear_edit_action_rows() -> void:
	for edit_action_row: EditActionRow in _edit_action_rows:
		remove_child(edit_action_row)
	_edit_action_rows.clear()


func add_edit_action_rows() -> void:
	var header_margin = 80
	var row_margin = 10
	var row_location = header_margin
	var row_size = 100 #Calculate this based on size of formulas
	for action: Action in actions:
		var row = edit_action_row_template.instantiate()
		row.set_action(action)
		row.set_row_location(row_location)
		row.size.y = row_size
		add_child(row)
		_edit_action_rows.append(row)
		row_location = row_location + row_size + row_margin


func _on_add_button_button_up() -> void:
	var action = Action.new("Action " + str(actions.size() + 1), true)
	actions.append(action)
	clear_edit_action_rows()
	add_edit_action_rows()
	model_changed.emit()

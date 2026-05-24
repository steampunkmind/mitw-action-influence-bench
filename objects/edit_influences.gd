class_name EditInfluences extends VBoxContainer

var _action: Action

@export var edit_influence_template: PackedScene

var _edit_influences: Array[EditInfluence]

func set_action(action: Action) -> void:
	_action = action
	
	for influence: Influence in action.get_influences():
		var row: EditInfluence = edit_influence_template.instantiate()
		row.set_influence(influence)
		add_child(row)
		_edit_influences.append(row)


func _on_add_influence_button_pressed() -> void:
	print("_on_add_influence_button_pressed")

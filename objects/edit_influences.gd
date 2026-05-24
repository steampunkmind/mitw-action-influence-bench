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
		
		
		#print influence.get_sensor_name()
		 #-> Array[Influence]:
	#return _influences
	
	#var row = edit_action_row_template.instantiate()
		#row.set_action(action)
		#row.delete_action_button_pressed.connect(_delete_action_button_pressed.bind(action))
		#row.model_edited.connect(_model_edited)
		#$ActionScroll/Actions.add_child(row)
		#_edit_action_rows.append(row)
		
	
	


func _on_add_influence_button_pressed() -> void:
	print("_on_add_influence_button_pressed")

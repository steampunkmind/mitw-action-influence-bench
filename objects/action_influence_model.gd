class_name ActionInfluenceModel extends Object

var _actions: Array[Action]:
	get = get_actions, set = set_actions
var _edit_mode: bool = false:
	get = get_edit_mode, set = set_edit_mode

## Actions ##
func get_actions() -> Array[Action]:
	return _actions


func set_actions(value: Array[Action]):
	_actions = value


func get_action_dicts() -> Array:
	var result = []
	for action: Action in _actions:
		result.append(action.get_dict())	
	return result


func set_action_dicts(action_dicts: Array) -> void:
	fill_actions(action_dicts)


func fill_actions(action_array: Array) -> void:
	_actions.clear()
	for action_dict: Dictionary in action_array:
		var influences: Array[Influence]
		var influence_dict = action_dict.get("influences")
		for signal_name: String in influence_dict:
			var expressions = influence_dict.get(signal_name)
			var formula = Formula.new(expressions)
			var influence = Influence.new(signal_name, formula)
			influences.append(influence)
		
		_actions.append(Action.new(action_dict.get("name"), action_dict.get("visible"), influences))


## Edit Mode ##
func get_edit_mode() -> bool:
	return _edit_mode


func set_edit_mode(value: bool) -> void:
	_edit_mode = value

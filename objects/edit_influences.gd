extends Control

var _action: Action


func set_action(action: Action) -> void:
	_action = action
	$Text.text = _to_text()
	set_custom_minimum_size($Text.get_minimum_size())


func _to_text() -> String:
	var text: String = "behavioral: "
	if _action.get_behavioral():
		text += "true\r"
	else:
		text += "false\r"
	
	for influence: Influence in _action.get_influences():
		text += influence.get_sensor_name()
		text += "("
		var i: int = 0
		for key: String in influence.get_formula().get_expressions().keys():
			if i > 0:
				text += ", "
			text += key
			i += 1
		text += ")\r"
	return text

extends Control

var _action: Action


func set_action(action: Action) -> void:
	_action = action
	$Text.text = _to_text()


func _to_text() -> String:
	var text: String = ""
	for influence: Influence in _action.get_influences():
		if text.length() > 0:
			text += ", "
		text += influence.get_sensor_name()
		
		var formula: Formula = influence.get_formula()
		text += "("
		var i: int = 0
		for key: String in formula.get_expressions().keys():
			if i > 0:
				text += ", "
			text += key
			i += 1
		text += ")"
	text += ", behavioral: "
	if _action.get_behavioral():
		text += "true"
	else:
		text += "false"
	return text

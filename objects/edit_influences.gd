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
		text += influence.to_text() + "\r"
	
	return text

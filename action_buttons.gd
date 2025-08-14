extends ColorRect

signal action_button_pressed

@export var action_array: Array[Dictionary]
@export var action_button_template: Button

var new_button_location
var action_buttons: Array[Button]
var actions: Array[Action]:
	get = get_actions, set = set_actions
var edit_mode: bool = false:
	get = get_edit_mode, set = set_edit_mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ActionButtonTemplate.visible = false
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func get_actions() -> Array[Action]:
	return actions
	
	
func set_actions(value: Array[Action]):
	actions = value
	update_buttons()
	
	
func update_buttons():
	clear_action_buttons()
	add_action_buttons()
	_show_hide_buttons()
	
func _action_button_pressed(action: Action) -> void:
	action_button_pressed.emit(action)
	
	
func set_new_model() -> void:
	actions.clear()
	fill_actions(action_array)
	update_buttons()
	
	
func init_action() -> void:
	# called by bench to init after other scenes are set up. 
	_action_button_pressed(actions[0])
	
	
func get_action_dicts() -> Array:
	var result = []
	for action: Action in actions:
		result.append(action.get_dict())	
	return result
	
	
func set_action_dicts(action_dicts: Array) -> void:
	actions.clear()
	fill_actions(action_dicts)
	update_buttons()
	
	
func fill_actions(action_array: Array) -> void:
	for action_dict: Dictionary in action_array:
		var influences: Array[Influence]
		var influence_dict = action_dict.get("influences")
		for signal_name: String in influence_dict:
			var expressions = influence_dict.get(signal_name)
			var formula = Formula.new(expressions)
			var influence = Influence.new(signal_name, formula)
			influences.append(influence)
		
		actions.append(Action.new(action_dict.get("name"), action_dict.get("visible"), influences))
	
	
func clear_action_buttons():
	for action_button: Button in action_buttons:
		remove_child(action_button)
	action_buttons.clear()
	
	
func add_action_buttons():
	new_button_location = $ActionButtonTemplate.position.x
	for action: Action in actions:
		add_action_button(action)
	
	
func add_action_button(action: Action) -> void:
	var button = $ActionButtonTemplate.duplicate(1)
	var button_margin = button.position.x
	button.name = action.get_name()
	button.text = action.get_name()
	button.offset_left = new_button_location
	button.pressed.connect(_action_button_pressed.bind(action))
	add_child(button)
	action_buttons.append(button)
	button.visible = true
	new_button_location = button.position.x + (button.size.x * button.get_scale().x) + button_margin
	
	
# signal from signal graph
# Probably should make model data object that holds actions and sensor data. 
# And then remove this and let the signal graph take care of it directly
func _on_signal_graph_select_action(action_name: String) -> void:
	for action: Action in actions:
		if (action.get_name() == action_name):
			action_button_pressed.emit(action)
			break
	
	
func get_edit_mode() -> bool:
	return edit_mode
	
	
func set_edit_mode(value: bool) -> void:
	edit_mode = value
	_show_hide_buttons()
	
	
func _show_hide_buttons():
	for action: Action in actions:
		if !action.get_visible():
			var child = find_child(action.get_name(), false, false)
			if edit_mode:
				child.show()
			else:
				child.hide()
	
	

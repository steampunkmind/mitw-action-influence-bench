extends ColorRect

signal action_button_pressed

@export var action_array: Array[Dictionary]
@export var action_button_template: Button

var new_button_location
var action_buttons: Array[Button]
var actions: Array[Action]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ActionButtonTemplate.visible = false
	fill_actions(action_array)
	add_action_buttons()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _action_button_pressed(action: Action) -> void:
	action_button_pressed.emit(action)
	
	
func _on_add_button_button_up() -> void:
	var action = Action.new("Untitled " + str(actions.size() + 1))
	actions.append(action)
	clear_action_buttons()
	add_action_buttons()
	
	
func set_new_model() -> void:
	actions.clear()
	fill_actions(action_array)
	clear_action_buttons()
	add_action_buttons()
	
func get_action_dicts() -> Array:
	var result = []
	for action: Action in actions:
		result.append(action.get_dict())	
	return result
	
	
func set_action_dicts(action_dicts: Array) -> void:
	actions.clear()
	fill_actions(action_dicts)
	clear_action_buttons()
	add_action_buttons()
	
	
func fill_actions(action_array: Array) -> void:
	for action_dict: Dictionary in action_array:
		var influences: Array[Influence]
		var influence_dict = action_dict.get("influences")
		for signal_name: String in influence_dict:
			var expressions = influence_dict.get(signal_name)
			# expressions was originally an array, 
			# but an array is not needed so just use the first item in the array
			# remove this when values from editor are fixed and array is removed.
			if expressions is Array:
				if (expressions.size() > 0):
					expressions = expressions.get(0)
					
			var formula = Formula.new(expressions)
			var influence = Influence.new(signal_name, formula)
			influences.append(influence)
		
		actions.append(Action.new(action_dict.get("name"), influences))
	
	
func clear_action_buttons():
	for action_button: Button in action_buttons:
		remove_child(action_button)
	action_buttons.clear()
	
	
func add_action_buttons():
	new_button_location = $ActionButtonTemplate.position.x
	for action: Action in actions:
		add_action_button(action)
	
	# Init bench with first action in array
	_action_button_pressed(actions[0])
	
	
func add_action_button(action: Action) -> void:
	var button = $ActionButtonTemplate.duplicate(1)
	var button_margin = button.position.x
	button.text = action.get_name()
	button.offset_left = new_button_location
	button.pressed.connect(_action_button_pressed.bind(action))
	add_child(button)
	action_buttons.append(button)
	button.visible = true
	new_button_location = button.position.x + (button.size.x * button.get_scale().x) + button_margin
	
	

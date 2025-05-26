extends ColorRect

signal action_button_pressed

@export var action_array: Array[Dictionary]
@export var action_button_template: Button

var new_button_location

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# fill actions from action_array
	var actions: Array[Action]
	for action_dict: Dictionary in action_array:
		var action = Action.new()
		action.name = action_dict.get("name")
		var dict_influence = action_dict.get("influences")
		for signal_name: String in dict_influence:
			var influence = Influence.new()
			influence.signal_name = signal_name
			
			# expressions was originally an array, 
			# but an array is not needed so just use the first item in the array
			var expressions = dict_influence.get(signal_name)
			if (expressions.size() > 0):
				var formula = Formula.new()
				formula.expressions = expressions.get(0)
				influence.formula = formula
				
			action.influences.append(influence)
		actions.insert(actions.size(), action)
	get_parent().actions = actions
	
	$ActionButtonTemplate.visible = false
	new_button_location = $ActionButtonTemplate.position.x
	for action: Action in actions:
		add_action_button(action)
	
	# Init bench with first action in array
	_action_button_pressed(actions[0])
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _action_button_pressed(action: Action) -> void:
	action_button_pressed.emit(action)
	
	
func _on_add_button_button_up() -> void:
	var actions = get_parent().actions
	var action = Action.new()
	action.name = "Untitled " + str(actions.size() + 1)
	actions.insert(actions.size(), action)
	add_action_button(action)
	
	
### Utils ###
func add_action_button(action: Action) -> void:
	var button = $ActionButtonTemplate.duplicate(1)
	var button_margin = button.position.x
	button.text = action.name
	button.offset_left = new_button_location
	button.pressed.connect(_action_button_pressed.bind(action))
	add_child(button)
	button.visible = true
	new_button_location = button.position.x + (button.size.x * button.get_scale().x) + button_margin
	
	

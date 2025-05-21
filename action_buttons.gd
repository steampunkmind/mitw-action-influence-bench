extends ColorRect

signal action_button_pressed

@export var action_array: Array[Dictionary]
@export var action_button_template: Button

var new_button_location

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ActionButtonTemplate.visible = false
	new_button_location = $ActionButtonTemplate.position.x
	for action_dict: Dictionary in action_array:
		add_action_button(action_dict)
	
	# Init bench with first action in array
	_action_button_pressed(action_array[0])
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _action_button_pressed(dict: Dictionary) -> void:
	action_button_pressed.emit(dict)
	
	
func _on_add_button_button_up() -> void:
	var action_dict = Dictionary()
	var action_name = "Untitled " + str(action_array.size() + 1)
	action_dict.set("name", action_name)
	action_array.insert(action_array.size(), action_dict)
	add_action_button(action_dict)
	
	
### Utils ###
func add_action_button(action_dict: Dictionary) -> void:
	var button = $ActionButtonTemplate.duplicate(1)
	var button_margin = button.position.x
	button.text = action_dict.name
	button.offset_left = new_button_location
	button.pressed.connect(_action_button_pressed.bind(action_dict))
	add_child(button)
	button.visible = true
	new_button_location = button.position.x + (button.size.x * button.get_scale().x) + button_margin
	
	

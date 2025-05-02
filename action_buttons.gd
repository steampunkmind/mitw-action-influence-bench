extends ColorRect

signal action_button_pressed

@export var action_array: Array[Dictionary]
@export var action_button_template: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button = $ActionButtonTemplate 
	var button_margin = button.position.x
	var button_location = button.position.x
	var button_scale = button.get_scale()
	for action_dict: Dictionary in action_array:
		button = $ActionButtonTemplate.duplicate(1)
		button.text = action_dict.name
		button.offset_left = button_location
		button.pressed.connect(_action_button_pressed.bind(action_dict))
		add_child(button)
		button_location = button.position.x + (button.size.x * button_scale.x) + button_margin
		
	$ActionButtonTemplate.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func _action_button_pressed(dict: Dictionary) -> void:
	action_button_pressed.emit(dict)
	
	

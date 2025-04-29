extends ColorRect

@export var action_array: Array[Dictionary]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button_location = 16
	var button_scale = Vector2(2.8, 2.8) 
	for action_dict: Dictionary in action_array:
		var button = Button.new()
		button.text = action_dict.name
		button.set_scale(button_scale)
		button.offset_top = 16
		button.offset_left = button_location
		add_child(button)
		button_location = button_location + 160


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

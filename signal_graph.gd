class_name SignalGraph
extends ColorRect

@export var signal_array_dicts: Array[Dictionary]
@export var signal_graph_row_template: PackedScene

var name_line_offset: float
var action_names: Array[Control]
var action_lines: Array[Node2D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ActionNameTemplate.visible = false
	$ActionLineTemplate.visible = false
	name_line_offset = $ActionLineTemplate.position.x - ($ActionNameTemplate.position.x + $ActionNameTemplate.size.x)
	var header_margin = 100
	var row_margin = 10
	var row_size = (size.y - header_margin) / signal_array_dicts.size()
	var row_location = header_margin
	for signal_dict: Dictionary in signal_array_dicts:
		var row = signal_graph_row_template.instantiate()
		row.set_row_location(row_location)
		row.set_signal_name(signal_dict.name)
		row.set_signal_min(signal_dict.min)
		row.set_signal_max(signal_dict.max)
		row.set_signal_value(signal_dict.value)
		row.size.y = row_size - row_margin
		add_child(row)
		row_location = row_location + row_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func add_frame_to_graph() -> void:
	for control in action_names:
		if (control.position.x + control.size.x + name_line_offset < size.x):
			control.position.x = control.position.x + 1
			
	var waiting_count = 0
	for node in action_lines:
		node.position.x
		if (node.position.x < size.x):
			node.position.x = node.position.x + 1
		else:
			waiting_count += 1
	
	if (waiting_count > 1):
		action_names.remove_at(action_names.size() - 1)
		action_lines.remove_at(action_lines.size() - 1)
		remove_child(action_names.get(action_names.size() - 1))
		remove_child(action_lines.get(action_lines.size() - 1))
	
	for child in get_children():
		if (is_instance_of(child, SignalGraphRow)):
			child.add_frame_to_graph()
	
	
func set_action(dict: Dictionary) -> void:
	var new_action_name = $ActionNameTemplate.duplicate(1)
	new_action_name.visible = true
	new_action_name.text = dict.name
	add_child(new_action_name)
	action_names.insert(0, new_action_name)
	
	var new_action_line = $ActionLineTemplate.duplicate(1)
	new_action_line.visible = true
	add_child(new_action_line)
	action_lines.insert(0, new_action_line)
	
	

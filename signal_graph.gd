class_name SignalGraph
extends ColorRect

@export var signal_array_dicts: Array[Dictionary]
@export var signal_graph_row_template: PackedScene

var name_line_offset: float
var action_names: Array[Control]
var action_lines: Array[Node2D]
var signal_graph_rows: Dictionary[String, SignalGraphRow]


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
		row.set_signal_dict(signal_dict)
		row.set_row_location(row_location)
		row.size.y = row_size - row_margin
		add_child(row)
		signal_graph_rows.set(signal_dict.name, row)
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
	
	for row in signal_graph_rows.values():
		row.add_frame_to_graph()
	
	
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
	
	## Set influences
	var influences = dict.get("influences")
	if (influences != null):
		for key: String in influences.keys():
			var formulas = influences.get(key)
			if (formulas is Array):
				var signal_graph_row = signal_graph_rows.get(key)
				signal_graph_row.set_formulas(formulas)
	
	
### Support for signal graph rows ###
# All signal values that depend on other rows 
# should be calculated by the SignalGraph
# SignalGraphRows should be blind to other rows.
func calc_signal_formulas(source_row: SignalGraphRow, formulas: Dictionary) -> float:
	var result = source_row.get_signal_value()
	var limit_value = false
	for key: String in formulas.keys():
		#This should be done with a base class and a subclass for each formula type
		match (key):
			"Linear":
				var linear_change = formulas.get(key)
				result += linear_change
			"Sum":
				result = 0.0
				var signal_names = formulas.get(key)
				for signal_name: String in signal_names:
					var signal_graph_row = signal_graph_rows.get(signal_name)
					result += signal_graph_row.get_signal_value()
			"Max Limit":
				var signal_names = formulas.get(key)
				for signal_name: String in signal_names:
					var signal_graph_row = signal_graph_rows.get(signal_name)
					if (signal_graph_row.get_signal_value() >= signal_graph_row.get_signal_max()):
						limit_value = true
						break
			"Outflow Percent":
				var outflow_percent = formulas.get(key)
				result -= result * (outflow_percent/100) 
			"Inflow Percent":
				var formula = formulas.get(key)
				for formula_dict: Dictionary in formula:
					var signal_name = formula_dict.get("signal_name")
					var inflow_percent = formula_dict.get("inflow_percent")
					var signal_graph_row = signal_graph_rows.get(signal_name)
					var signal_value = signal_graph_row.get_signal_value()
					result += signal_value * (inflow_percent/100)
			_:
				print(key + " formula not found.")
				
	if (limit_value && result > source_row.get_signal_value()):
		return source_row.get_signal_value()
		
	return result
	
	

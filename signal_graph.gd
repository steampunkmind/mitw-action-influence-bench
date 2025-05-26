class_name SignalGraph
extends ColorRect

@export var signal_array_dicts: Array[Dictionary]
@export var signal_graph_row_template: PackedScene

var name_line_offset: float
var init_action = null
var action_names: Array[Control]
var action_lines: Array[Node2D]
var signal_graph_rows: Dictionary[String, SignalGraphRow]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ActionNameTemplate.visible = false
	$ActionLineTemplate.visible = false
	name_line_offset = $ActionLineTemplate.position.x - ($ActionNameTemplate.position.x + $ActionNameTemplate.size.x)
	add_signal_graph_rows()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_add_button_button_up() -> void:
	# Clear all current children to clear screen
	for action_name: Control in action_names:
		remove_child(action_name)
	action_names.clear()
	
	for action_line: Node2D in action_lines:
		remove_child(action_line)
	action_lines.clear()
		
	for signal_graph_row: SignalGraphRow in signal_graph_rows.values():
		remove_child(signal_graph_row)
	
	var signal_dict = Dictionary()
	signal_dict.set('name', "Untitled " + str(signal_array_dicts.size()+1))
	signal_dict.set('min', 0 as float)
	signal_dict.set('max', 100 as float)
	signal_dict.set('value', 50 as float)
	signal_array_dicts.insert(signal_array_dicts.size(), signal_dict)
	
	signal_graph_rows.clear()
	add_signal_graph_rows()
	set_action(init_action)
	
	
func add_signal_graph_rows() -> void:
	var header_margin = 80
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
	
	
func set_action(action: Action) -> void:
	if (init_action == null):
		init_action = action
	var new_action_name = $ActionNameTemplate.duplicate(1)
	new_action_name.visible = true
	new_action_name.text = action.name
	add_child(new_action_name)
	action_names.insert(0, new_action_name)
	
	var new_action_line = $ActionLineTemplate.duplicate(1)
	new_action_line.visible = true
	add_child(new_action_line)
	action_lines.insert(0, new_action_line)
	
	## Set influences
	var influences = action.influences
	if (influences != null):
		for influence: Influence in influences:
			#TEMP
			print(influence.signal_name)
			print(influence.formulas)
	
	
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
	
	

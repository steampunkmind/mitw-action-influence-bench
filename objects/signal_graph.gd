class_name SignalGraph
extends ColorRect

signal model_changed
signal select_action
signal shuffle_action

@export var signal_array_dicts: Array[Dictionary]
@export var signal_graph_row_template: PackedScene

var _model: ActionInfluenceModel
var name_line_offset: float
var action_names: Array[Control]
var action_lines: Array[Node2D]
var signal_graph_rows: Dictionary[String, SignalGraphRow]
var sensors: Array[Sensor]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ActionNameTemplate.visible = false
	$ActionLineTemplate.visible = false
	name_line_offset = $ActionLineTemplate.position.x - ($ActionNameTemplate.position.x + $ActionNameTemplate.size.x)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func set_model(value: ActionInfluenceModel):
	_model = value


func set_new_model() -> void:
	clear_signal_graph_rows()
	fill_sensors(signal_array_dicts)
	add_signal_graph_rows()
	
	
func _on_add_button_button_up() -> void:
	clear_signal_graph_rows()
	new_signal_graph_row()
	add_signal_graph_rows()
	model_changed.emit()
	
	
func get_sensor_dicts() -> Array:
	var sensor_dicts = []
	for sensor: Sensor in sensors:
		sensor_dicts.append(sensor.get_dict())	
	return sensor_dicts
	
	
func set_sensor_dicts(sensor_dicts: Array) -> void:
	clear_signal_graph_rows()
	fill_sensors(sensor_dicts)
	add_signal_graph_rows()
	
	
func fill_sensors(sensor_dicts: Array) -> void:
	sensors = []
	for signal_dict: Dictionary in sensor_dicts:
		var name = signal_dict.get('name')
		var min = signal_dict.get('min')
		var max = signal_dict.get('max')
		var value = signal_dict.get('value')
		sensors.append(Sensor.new(name, min, max, value))
	
	
func clear_signal_graph_rows() -> void:
	# Clear all current children to clear screen
	for action_name: Control in action_names:
		remove_child(action_name)
	action_names.clear()
	
	for action_line: Node2D in action_lines:
		remove_child(action_line)
	action_lines.clear()
		
	for signal_graph_row: SignalGraphRow in signal_graph_rows.values():
		remove_child(signal_graph_row)
	
	signal_graph_rows.clear()
	
	
func new_signal_graph_row() -> void:
	var name = "Untitled " + str(sensors.size()+1)
	sensors.append(Sensor.new(name, 0, 100, 50))
	
	
func add_signal_graph_rows() -> void:
	var header_margin = 80
	var row_margin = 10
	var row_location = header_margin
	var row_size = (size.y - header_margin) / sensors.size()
	for sensor: Sensor in sensors:
		var row = signal_graph_row_template.instantiate()
		row.set_sensor(sensor)
		row.set_row_location(row_location)
		row.size.y = row_size - row_margin
		row.set_edit_mode(_model.get_edit_mode())
		add_child(row)
		signal_graph_rows.set(sensor.get_name(), row)
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
	if _model.get_edit_mode() or action.get_visible():
		var new_action_name = $ActionNameTemplate.duplicate(1)
		new_action_name.visible = true
		new_action_name.text = action.get_name()
		add_child(new_action_name)
		action_names.insert(0, new_action_name)
	
		var new_action_line = $ActionLineTemplate.duplicate(1)
		new_action_line.visible = true
		add_child(new_action_line)
		action_lines.insert(0, new_action_line)
	
	## Set influences
	for influence: Influence in action.get_influences():
		var signal_graph_row = signal_graph_rows.get(influence.get_signal_name())
		if signal_graph_row != null :
			signal_graph_row.set_formula(influence.get_formula(), _model.get_edit_mode())
	
	
### Support for signal graph rows ###
# All signal values that depend on other rows 
# should be calculated by the SignalGraph
# SignalGraphRows should be blind to other rows.
func calc_signal_formulas(source_row: SignalGraphRow, formulas: Dictionary) -> float:
	var result = source_row.get_signal_value()
	var limit_value = false
	for key: String in formulas.keys():
		#This should be done with a base class and a subclass for each formula type
		# remove group extension from key for formula type
		var formula_type = key.get_basename() 
		match (formula_type):
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
			"Select Action":
				var formula = formulas.get(key)
				var value = formula.get("value")
				if value == null:
					value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
				else:
					value = value - 1
				if (value < 0):
					var actions = formula.get("actions")
					var i = randi() % actions.size()
					var action_name = actions[i]
					# For now send a signal to the Action buttons
					# But I think it would be better to have this object 
					# have direct access to model_data object that holds 
					# the action and sensor (currently called signal) data 
					# and the same for the other emits below
					select_action.emit(action_name) # signal to action buttons
					value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
				formula.set("value", value)
				formulas.set(key, formula)
			"Delay Action":
				var formula = formulas.get(key)
				var value = formula.get("value")
				if value == null:
					value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
				else:
					value = value - 1
				if (value < 0):
					var action = formula.get("action")
					select_action.emit(action) # signal to action buttons
					formula.erase("value")
					formulas.set(key, formula)
					formulas.erase(key)
				else:
					formula.set("value", value)
					formulas.set(key, formula)
			"Shuffle Action":
				var formula = formulas.get(key)
				var value = formula.get("value")
				if value == null:
					value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
				else:
					value = value - 1
				if (value < 0):
					shuffle_action.emit(formula.get("actions")) # signal to action buttons
					value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
				formula.set("value", value)
				formulas.set(key, formula)
			_:
				print(formula_type + " formula not found.")
				
	if (limit_value && result > source_row.get_signal_value()):
		return source_row.get_signal_value()
		
	return result
	
	
func update_edit_mode() -> void:
	for signal_graph_row: SignalGraphRow in signal_graph_rows.values():
		signal_graph_row.set_edit_mode(_model.get_edit_mode())
	

class_name SensorGraph
extends ColorRect

signal model_changed
signal select_action
signal shuffle_action

@export var sensor_array_dicts: Array[Dictionary]
@export var sensor_graph_row_template: PackedScene

var _model: ActionInfluenceModel
var name_line_offset: float
var action_names: Array[Control]
var action_lines: Array[Node2D]
var sensor_graph_rows: Dictionary[String, SensorGraphRow]


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
	_model.fill_sensors(sensor_array_dicts)
	update_sensors()
	
	
func _on_add_button_button_up() -> void:
	_model.new_sensor()
	clear_sensor_graph_rows()
	add_sensor_graph_rows()
	model_changed.emit()
	
	
func update_sensors() -> void:
	clear_sensor_graph_rows()
	add_sensor_graph_rows()
	
	
func clear_sensor_graph_rows() -> void:
	# Clear all current children to clear screen
	for action_name: Control in action_names:
		remove_child(action_name)
	action_names.clear()
	
	for action_line: Node2D in action_lines:
		remove_child(action_line)
	action_lines.clear()
		
	for sensor_graph_row: SensorGraphRow in sensor_graph_rows.values():
		remove_child(sensor_graph_row)
	
	sensor_graph_rows.clear()
	
	
func add_sensor_graph_rows() -> void:
	var header_margin = 80
	var row_margin = 10
	var row_location = header_margin
	var row_size = (size.y - header_margin) / _model.get_sensors().size()
	for sensor: Sensor in _model.get_sensors():
		var row = sensor_graph_row_template.instantiate()
		row.set_sensor(sensor)
		row.set_row_location(row_location)
		row.size.y = row_size - row_margin
		row.set_edit_mode(_model.get_edit_mode())
		add_child(row)
		sensor_graph_rows.set(sensor.get_name(), row)
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
	
	for row in sensor_graph_rows.values():
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
		var sensor_graph_row = sensor_graph_rows.get(influence.get_sensor_name())
		if sensor_graph_row != null :
			sensor_graph_row.set_formula(influence.get_formula(), _model.get_edit_mode())
	
	
func update_edit_mode() -> void:
	for sensor_graph_row: SensorGraphRow in sensor_graph_rows.values():
		sensor_graph_row.set_edit_mode(_model.get_edit_mode())
	
	
### Support for sensor graph rows ###
# All sensor values that depend on other rows 
# should be calculated by the SensorGraph
# SensorGraphRows should be blind to other rows.
func sensor_formulas_value(source_row: SensorGraphRow, formulas: Dictionary) -> float:
	var result = source_row.get_sensor_value()
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
				var sensor_names = formulas.get(key)
				for sensor_name: String in sensor_names:
					var sensor_graph_row = sensor_graph_rows.get(sensor_name)
					result += sensor_graph_row.get_sensor_value()
			"Max Limit":
				var sensor_names = formulas.get(key)
				for sensor_name: String in sensor_names:
					var sensor_graph_row = sensor_graph_rows.get(sensor_name)
					if (sensor_graph_row.get_sensor_value() >= sensor_graph_row.get_sensor_max()):
						limit_value = true
						break
			"Outflow Percent":
				var outflow_percent = formulas.get(key)
				result -= result * (outflow_percent/100) 
			"Inflow Percent":
				var formula = formulas.get(key)
				for formula_dict: Dictionary in formula:
					var sensor_name = formula_dict.get("sensor_name")
					var inflow_percent = formula_dict.get("inflow_percent")
					var sensor_graph_row = sensor_graph_rows.get(sensor_name)
					var sensor_value = sensor_graph_row.get_sensor_value()
					result += sensor_value * (inflow_percent/100)
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
					# For now send a sensor to the Action buttons
					# But I think it would be better to have this object 
					# have direct access to model_data object that holds 
					# the action and sensor data 
					# and the same for the other emits below
					select_action.emit(action_name) # sensor to action buttons
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
					select_action.emit(action) # sensor to action buttons
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
					shuffle_action.emit(formula.get("actions")) # sensor to action buttons
					value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
				formula.set("value", value)
				formulas.set(key, formula)
			_:
				print(formula_type + " formula not found.")
				
	if (limit_value && result > source_row.get_sensor_value()):
		return source_row.get_sensor_value()
		
	return result
	
	
func sensor_formulas_text(sensor_formulas: Dictionary) -> String:
	var result = ""
	# should call to_string method in future SensorFormula Class
	if (sensor_formulas):
		for key: String in sensor_formulas:
			result += key + ": "
			var formula_value = sensor_formulas.get(key)
			# remove group extension from key for formula
			var formula_type = key.get_basename()
			match (formula_type):
				"Linear":
					result += str(formula_value)
				"Sum":
					result += "["
					var cnt = 0
					for sensor_name: String in formula_value:
						if (cnt > 0):
							result += ", "
						result += sensor_name
						cnt += 1
					result += "]"
				"Max Limit":
					result += "["
					var cnt = 0
					for sensor_name: String in formula_value:
						if (cnt > 0):
							result += ", "
						result += sensor_name
						cnt += 1
					result += "]"
				"Outflow Percent":
					result += str(formula_value)
				"Inflow Percent":
					result += "["
					var cnt = 0
					for sensor_inflow: Dictionary in formula_value:
						if (cnt > 0):
							result += ", "
						var sensor_name = sensor_inflow.get("sensor_name")
						var inflow_percent = sensor_inflow.get("inflow_percent")
						result += "{" + sensor_name + ": " + str(inflow_percent) + "}"
					result += "]"
				"Select Action", "Delay Action", "Shuffle Action":
					result += str(formula_value)
				_:
					print(formula_type + " formula not found.")
					
			result += "\r"
		
	return result
	
	

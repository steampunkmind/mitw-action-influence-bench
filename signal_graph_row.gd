class_name SignalGraphRow
extends ColorRect

var signal_min
var signal_max
var signal_value
var signal_formulas = {}
var _formulas_text = ""
var edit_mode: bool = false:
	get = get_edit_mode, set = set_edit_mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SignalValue.position.y = (size.y/2) - ($SignalValue.size.y/2)
	$SignalMin.position.y = size.y - $SignalValue.size.y

	var point = $StartLine.get_point_position(1)
	point.y = size.y
	$StartLine.set_point_position(1, point)
	
	point = $SignalLine.get_point_position(0)
	point.y = signal_value_y()
	$SignalLine.set_point_position(0, point)
	point = $SignalLine.get_point_position(1)
	point.y = signal_value_y()
	$SignalLine.set_point_position(1, point)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_row_location(y: float) -> void:
	var p = get_position()
	p.y = y
	set_position(p)
	
func set_sensor(sensor: Sensor) -> void:
	set_name(sensor.get_name()) # sets name of node
	set_signal_name(sensor.get_name()) #!needed?
	set_signal_min(sensor.get_min())
	set_signal_max(sensor.get_max())
	set_signal_value(sensor.get_value())
	
func set_signal_name(value: String) -> void:
	$Name.text = value
	
func set_signal_min(value: float) -> void:
	signal_min = value
	$SignalMin.text = str(value)
	
func set_signal_max(value: float) -> void:
	signal_max = value
	$SignalMax.text = str(value)

func get_signal_max() -> float:
	return signal_max
	
func set_signal_value(value: float) -> void:
	signal_value = value
	$SignalValue.text = str("%.1f" % value)

func get_signal_value() -> float:
	return signal_value
	
	
func add_frame_to_graph() -> void:
	var line = $SignalLine
		
	# Move points to right
	for i in range(line.get_point_count()):
		var point = line.get_point_position(i)
		point.x = point.x + 1
		line.set_point_position(i, point)
		
	# Remove if off right side
	if (line.get_point_position(0).x > size.x):
		line.remove_point(0)
	
	# Add new point
	var point = line.get_point_position(line.get_point_count()-1)
	point.x = point.x - 1
	update_signal_change_value()
	point.y = signal_value_y()
	line.add_point(point)
	
	if edit_mode:
		update_formulas_text()
		$Formulas.text = str(_formulas_text)
	
	
func set_formula(formula: Formula, edit_mode: bool) -> void:
	var expressions = formula.get_expressions()
	for key: String in expressions:
		signal_formulas.set(key, expressions.get(key))
	
	
### Utils ###	
func update_signal_change_value() -> void:
	if (signal_formulas != null):
		var new_signal_value = get_parent().calc_signal_formulas(self, signal_formulas)
		if (new_signal_value < signal_min):
			new_signal_value = signal_min
		elif (new_signal_value > signal_max):
			new_signal_value = signal_max
		set_signal_value(new_signal_value)
	
	
func signal_value_y() -> float:
	var value_above_min = signal_value - signal_min
	var range = signal_max - signal_min
	var ratio = size.y/range
	var scaled_value = value_above_min * ratio
	return size.y - scaled_value;
	
	
func update_formulas_text() -> void:
	_formulas_text = ""
	# should call to_string method in future SignalFormula Class
	if (signal_formulas):
		for key: String in signal_formulas:
			_formulas_text += key + ": "
			var formula_value = signal_formulas.get(key)
			# remove group extension from key for formula
			var formula_type = key.get_basename()
			match (formula_type):
				"Linear":
					_formulas_text += str(formula_value)
				"Sum":
					_formulas_text += "["
					var cnt = 0
					for signal_name: String in formula_value:
						if (cnt > 0):
							_formulas_text += ", "
						_formulas_text += signal_name
						cnt += 1
					_formulas_text += "]"
				"Max Limit":
					_formulas_text += "["
					var cnt = 0
					for signal_name: String in formula_value:
						if (cnt > 0):
							_formulas_text += ", "
						_formulas_text += signal_name
						cnt += 1
					_formulas_text += "]"
				"Outflow Percent":
					_formulas_text += str(formula_value)
				"Inflow Percent":
					_formulas_text += "["
					var cnt = 0
					for signal_inflow: Dictionary in formula_value:
						if (cnt > 0):
							_formulas_text += ", "
						var signal_name = signal_inflow.get("signal_name")
						var inflow_percent = signal_inflow.get("inflow_percent")
						_formulas_text += "{" + signal_name + ": " + str(inflow_percent) + "}"
					_formulas_text += "]"
				"Select Action", "Delay Action":
					_formulas_text += str(formula_value)
				_:
					print(formula_type + " formula not found.")
					
			_formulas_text += "\r"
			
	
	
func get_edit_mode() -> bool:
	return edit_mode
	
	
func set_edit_mode(value: bool) -> void:
	edit_mode = value
	if !edit_mode:
		$Formulas.text = str("")
		
		

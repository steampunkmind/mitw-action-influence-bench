class_name Sensor extends RefCounted

var _dict = {}
var _formulas = {}
var _types = {}

# Constructor
func _init(name: String, min: float, max: float, value: float):
	_dict.set('name', name)
	_dict.set('min', min)
	_dict.set('max', max)
	_dict.set('value', value)
	
	_types.set("Linear", SensorFormulaLinear.new())
	
func get_name():
	return _dict.get('name')
	
	
func get_min():
	return _dict.get('min')
	
	
func get_max():
	return _dict.get('max')
	
	
func get_value() -> float:
	return _dict.get('value')
	
	
func set_value(value: float):
	_dict.set('value', value)
	
	
func get_formulas() -> Dictionary:
	return _formulas
	
	
func set_formulas(value: Dictionary):
	_formulas = value
	
	
func get_dict() -> Dictionary:
	return _dict
	
	
### Formulas ###
func get_formula_value(sensor: Sensor, formulas: Dictionary) -> float:
	var result = sensor.get_value()
	var limit_value = false
	for key: String in formulas.keys():
		#This should be done with a base class and a subclass for each formula type
		# remove group extension from key for formula type
		var formula_type_name = key.get_basename() 
		var formula_type = _types.get(formula_type_name)
		if formula_type == null:
			print(formula_type_name + " formula type not found.")
		else:
			result = formula_type.get_value(result, key, formulas)
			
		#match (formula_type):
			#"Linear":
				#var linear_change = formulas.get(key)
				#result += linear_change
			#"Sum":
				#result = 0.0
				#var sensor_names = formulas.get(key)
				#for sensor_name: String in sensor_names:
					#var other_sensor = _model.get_sensor(sensor_name)
					#result += other_sensor.get_value()
			#"Max Limit":
				#var sensor_names = formulas.get(key)
				#for sensor_name: String in sensor_names:
					#var other_sensor = _model.get_sensor(sensor_name)
					#if (other_sensor.get_value() >= other_sensor.get_max()):
						#limit_value = true
						#break
			#"Outflow Percent":
				#var outflow_percent = formulas.get(key)
				#result -= result * (outflow_percent/100) 
			#"Inflow Percent":
				#var formula = formulas.get(key)
				#for formula_dict: Dictionary in formula:
					#var sensor_name = formula_dict.get("sensor_name")
					#var inflow_percent = formula_dict.get("inflow_percent")
					#var other_sensor = _model.get_sensor(sensor_name)
					#var sensor_value = other_sensor.get_value()
					#result += sensor_value * (inflow_percent/100)
			#"Select Action":
				#var formula = formulas.get(key)
				#var value = formula.get("value")
				#if value == null:
					#value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
				#else:
					#value = value - 1
				#if (value < 0):
					#var actions = formula.get("actions")
					#var i = randi() % actions.size()
					#var action_name = actions[i]
					#action_agent.select_action(action_name)
					#value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
				#formula.set("value", value)
				#formulas.set(key, formula)
			#"Delay Action":
				#var formula = formulas.get(key)
				#var value = formula.get("value")
				#if value == null:
					#value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
				#else:
					#value = value - 1
				#if (value < 0):
					#var action = formula.get("action")
					#action_agent.select_action(action)
					#formula.erase("value")
					#formulas.set(key, formula)
					#formulas.erase(key)
				#else:
					#formula.set("value", value)
					#formulas.set(key, formula)
			#"Shuffle Action":
				#var formula = formulas.get(key)
				#var value = formula.get("value")
				#if value == null:
					#value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
				#else:
					#value = value - 1
				#if (value < 0):
					#action_agent.shuffle_action(formula.get("actions"))
					#value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
				#formula.set("value", value)
				#formulas.set(key, formula)
			#_:
				#print(formula_type + " formula not found.")
				#
	if (limit_value && result > sensor.get_value()):
		return sensor.get_value()
		
	return result


func get_formula_text(sensor_formulas: Dictionary) -> String:
	var result = ""
	# should call to_string method in future SensorFormula Class
	if (sensor_formulas):
		for key: String in sensor_formulas:
			#result += key + ": "
			#var formula_value = sensor_formulas.get(key)
			# remove group extension from key for formula
			var formula_type_name = key.get_basename()
			var formula_type = _types.get(formula_type_name)
			if formula_type == null:
				print(formula_type_name + " formula type not found.")
			else:
				result = formula_type.get_text(result, key, sensor_formulas)
		#match (formula_type):
				#"Linear":
					#result += str(formula_value)
				#"Sum":
					#result += "["
					#var cnt = 0
					#for sensor_name: String in formula_value:
						#if (cnt > 0):
							#result += ", "
						#result += sensor_name
						#cnt += 1
					#result += "]"
				#"Max Limit":
					#result += "["
					#var cnt = 0
					#for sensor_name: String in formula_value:
						#if (cnt > 0):
							#result += ", "
						#result += sensor_name
						#cnt += 1
					#result += "]"
				#"Outflow Percent":
					#result += str(formula_value)
				#"Inflow Percent":
					#result += "["
					#var cnt = 0
					#for sensor_inflow: Dictionary in formula_value:
						#if (cnt > 0):
							#result += ", "
						#var sensor_name = sensor_inflow.get("sensor_name")
						#var inflow_percent = sensor_inflow.get("inflow_percent")
						#result += "{" + sensor_name + ": " + str(inflow_percent) + "}"
					#result += "]"
				#"Select Action", "Delay Action", "Shuffle Action":
					#result += str(formula_value)
				#_:
					#print(formula_type + " formula not found.")
					#
			result += "\r"
		
	return result
	

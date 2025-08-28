class_name SensorFormula extends RefCounted

signal select_action
signal shuffle_action

var _model: ActionInfluenceModel

# Constructor
func _init(value: ActionInfluenceModel):
	_model = value


func get_value(sensor: Sensor, formulas: Dictionary) -> float:
	var result = sensor.get_value()
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
					var other_sensor = _model.get_sensor(sensor_name)
					result += other_sensor.get_value()
			"Max Limit":
				var sensor_names = formulas.get(key)
				for sensor_name: String in sensor_names:
					var other_sensor = _model.get_sensor(sensor_name)
					if (other_sensor.get_value() >= other_sensor.get_max()):
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
					var other_sensor = _model.get_sensor(sensor_name)
					var sensor_value = other_sensor.get_value()
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
				
	if (limit_value && result > sensor.get_value()):
		return sensor.get_value()
		
	return result


func get_text(sensor_formulas: Dictionary) -> String:
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
	
	

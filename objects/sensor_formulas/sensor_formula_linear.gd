class_name SensorFormulaLinear extends SensorFormula

const TYPE = "Linear"

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	return value + formulas.get(key)
	
func get_text(text: String, key: String, formulas: Dictionary) -> String:
	return text + key + ": " + str(formulas.get(key))

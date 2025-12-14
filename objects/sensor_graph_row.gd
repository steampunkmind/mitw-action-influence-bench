class_name SensorGraphRow
extends ColorRect

var _model: ActionInfluenceModel
var _sensor: Sensor 
var edit_mode: bool = false:
	get = get_edit_mode, set = set_edit_mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SensorValue.position.y = (size.y/2) - ($SensorValue.size.y/2)
	$SensorMin.position.y = size.y - $SensorValue.size.y

	var point = $StartLine.get_point_position(1)
	point.y = size.y
	$StartLine.set_point_position(1, point)
	
	point = $SensorLine.get_point_position(0)
	point.y = sensor_value_y()
	$SensorLine.set_point_position(0, point)
	point = $SensorLine.get_point_position(1)
	point.y = sensor_value_y()
	$SensorLine.set_point_position(1, point)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_model(value: ActionInfluenceModel):
	_model = value


func set_row_location(y: float) -> void:
	var p = get_position()
	p.y = y
	set_position(p)
	
func set_sensor(sensor: Sensor) -> void:
	_sensor = sensor
	set_name(sensor.get_name()) # sets name of node
	$Name.text = sensor.get_name()
	
func set_sensor_name(value: String) -> void:
	_sensor.set_name(value)
	set_name(value) # sets name of node
	$Name.text = value
	
func set_sensor_min(value: float) -> void:
	_sensor.set_min(value)
	$SensorMin.text = str(value)
	
func set_sensor_max(value: float) -> void:
	_sensor.set_max(value)
	$SensorMax.text = str(value)

func get_sensor_max() -> float:
	return _sensor.get_max()
	
func set_sensor_value(value: float) -> void:
	_sensor.set_value(value)
	$SensorValue.text = str("%.1f" % value)

func get_sensor_value() -> float:
	return _sensor.get_value()
	
	
func add_frame_to_graph() -> void:
	var line = $SensorLine
		
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
	update_sensor_change_value()
	point.y = sensor_value_y()
	line.add_point(point)
	
	if edit_mode:
		$Formulas.text = str(_sensor.get_formula_text(_sensor.get_formulas()))


### Utils ###	
func update_sensor_change_value() -> void:
	set_sensor_value(_sensor.update_value())
	
	
func sensor_value_y() -> float:
	var value_above_min = _sensor.get_value() - _sensor.get_min()
	var range = _sensor.get_max() - _sensor.get_min()
	var ratio = size.y/range
	var scaled_value = value_above_min * ratio
	return size.y - scaled_value;
	
	
func get_edit_mode() -> bool:
	return edit_mode
	
	
func set_edit_mode(value: bool) -> void:
	edit_mode = value
	if !edit_mode:
		$Formulas.text = str("")
		
		

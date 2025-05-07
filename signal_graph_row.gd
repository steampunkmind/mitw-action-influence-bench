class_name SignalGraphRow
extends ColorRect

var signal_min
var signal_max
var signal_value
var signal_influence = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SignalValue.position.y = (size.y/2) - ($SignalValue.size.y/2)
	$ActionValue.position.y = (size.y/2) - ($ActionValue.size.y/2)
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
	
func set_signal_name(value: String) -> void:
	$Name.text = value
	
func set_signal_min(value: float) -> void:
	signal_min = value
	$SignalMin.text = str(value)
	
func set_signal_max(value: float) -> void:
	signal_max = value
	$SignalMax.text = str(value)

func set_signal_value(value: float) -> void:
	signal_value = value
	$SignalValue.text = str("%.1f" % value)
	
	
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

func set_influence(value: float):
	$ActionValue.text = str(value)
	signal_influence = value
	

# Utils	
func update_signal_change_value() -> void:
	var new_signal_value = signal_value + signal_influence
	if (new_signal_value < signal_min):
		new_signal_value = signal_min
	elif (new_signal_value > signal_max):
		new_signal_value = signal_max
	set_signal_value(new_signal_value)
	
	
func signal_value_y() -> float:
	return size.y - (signal_value * (size.y/(signal_max - signal_min)))
	
	

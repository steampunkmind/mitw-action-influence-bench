class_name SignalGraphRow
extends ColorRect

var signal_min
var signal_max
var signal_value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SignalValue.position.y = (size.y/2) - ($SignalValue.size.y/2)
	$SignalMax.position.y = size.y - $SignalValue.size.y

	var point = $StartLine.get_point_position(1)
	point.y = size.y
	$StartLine.set_point_position(1, point)
	
	point = $SignalLine.get_point_position(0)
	point.y = signal_value_y()
	$SignalLine.set_point_position(0, point)
	point = $SignalLine.get_point_position(1)
	point.y = signal_value_y()
	$SignalLine.set_point_position(1, point)
	
	
func signal_value_y() -> float:
	return size.y - (signal_value * (size.y/(signal_max - signal_min)))


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
	$SignalValue.text = str(value)

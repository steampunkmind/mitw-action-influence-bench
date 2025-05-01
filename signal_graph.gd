class_name SignalGraph
extends ColorRect

@export var signal_array_dicts: Array[Dictionary]
@export var signal_graph_row_template: PackedScene

var frame_count: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var header_margin = 100
	var row_margin = 10
	var row_size = (size.y - header_margin) / signal_array_dicts.size()
	var row_location = header_margin
	for signal_dict: Dictionary in signal_array_dicts:
		var row = signal_graph_row_template.instantiate()
		row.set_row_location(row_location)
		row.set_signal_name(signal_dict.name)
		row.set_signal_min(signal_dict.min)
		row.set_signal_max(signal_dict.max)
		row.set_signal_value(signal_dict.value)
		row.size.y = row_size - row_margin
		add_child(row)
		row_location = row_location + row_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func add_frame() -> void:
	frame_count = frame_count + 1
	for child in get_children():
		if (is_instance_of(child, SignalGraphRow)):
			child.add_frame_to_graph()
	
	

class_name SensorGraph
extends ColorRect

signal model_changed

@export var sensor_array_dicts: Array[Dictionary]
@export var sensor_graph_row_template: PackedScene

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
	
	
func set_new_model() -> void:
	MITW.aim_model().fill_sensors(sensor_array_dicts)
	update_sensors()
	
	
func _on_add_button_button_up() -> void:
	MITW.aim_model().new_sensor()
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
	var row_size = (size.y - header_margin) / MITW.aim_model().get_sensors().size()
	for sensor: Sensor in MITW.aim_model().get_sensors():
		var row = sensor_graph_row_template.instantiate()
		row.set_sensor(sensor)
		row.set_row_location(row_location)
		row.size.y = row_size - row_margin
		row.set_model(MITW.aim_model())
		row.set_edit_mode(MITW.aim_model().get_edit_mode())
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
	if MITW.aim_model().get_edit_mode() or action.get_behavioral():
		var new_action_name = $ActionNameTemplate.duplicate(1)
		new_action_name.visible = true
		new_action_name.text = action.get_name()
		add_child(new_action_name)
		action_names.insert(0, new_action_name)
	
		var new_action_line = $ActionLineTemplate.duplicate(1)
		new_action_line.visible = true
		add_child(new_action_line)
		action_lines.insert(0, new_action_line)


func update_edit_mode() -> void:
	for sensor_graph_row: SensorGraphRow in sensor_graph_rows.values():
		sensor_graph_row.set_edit_mode(MITW.aim_model().get_edit_mode())
	
	

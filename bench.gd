extends ColorRect

@export var frame_rate: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FrameRateSlider.value = frame_rate
	$FrameRateValue.text = str(frame_rate)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _on_frame_rate_slider_value_changed(new_value: float) -> void:
	if (new_value == 0):
		$FrameRateValue.text = "PAUSED"
		$Timer.paused = true
	else:
		$FrameRateValue.text = str(new_value)
		$Timer.paused = false
	
	$Timer.set_wait_time(1/new_value)
	frame_rate = new_value
	
	
func _on_timer_timeout() -> void:
	$SignalGraph.add_frame_to_graph()


func _on_action_button_pressed(action: Action) -> void:
	$SignalGraph.set_action(action)
	
	
func _on_load_button_pressed() -> void:
	$OpenFileDialog.popup_centered_ratio()
	
	
func _on_open_file_dialog_file_selected(path: String) -> void:
	$ModelPath.text = path
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	
	$ActionButtons.set_action_dicts(json.get('actions') as Array)
	$SignalGraph.set_sensor_dicts(json.get('sensors') as Array)
	$SaveButton.visible = true
	$ModelPath.visible = true
	
	
func get_dict() -> Dictionary:
	var dict = {}
	dict.set('actions', $ActionButtons.get_action_dicts())
	dict.set('sensors', $SignalGraph.get_sensor_dicts())
	return dict
	
	
func _on_save_button_pressed() -> void:
	var file = FileAccess.open($ModelPath.text, FileAccess.WRITE)
	var content = JSON.stringify(get_dict(), "\t") # Remove the tab to reduce file size someday?
	file.store_line(content)
	
	

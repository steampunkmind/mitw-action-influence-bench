extends ColorRect

@export var frame_rate: float
var actions: Array[Action]
var sensors: Array[Sensor]

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
	var content = file.get_as_text()
	print(content) # load this into the model
	$SaveButton.visible = true
	$ModelPath.visible = true
	
	
func _on_save_button_pressed() -> void:
	var file = FileAccess.open($ModelPath.text, FileAccess.WRITE)
	var content = "this is a test string 67898"
	print(content)
	file.store_line(content)
	
	

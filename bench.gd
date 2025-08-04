extends ColorRect

const DONT_SAVE = "Don't Save"

var _is_model: bool = false
var _is_model_file: bool = false
var _close_after_save: bool = false

@export var frame_rate: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FrameRateSlider.value = frame_rate
	$FrameRateValue.text = str(frame_rate)
	$CloseConfirmationDialog.add_button("Don't Save", false, DONT_SAVE)
	_set_is_model(false)
	_set_is_dirty(false)
	
	
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
	
	
## File Functions ##
func _on_new_button_pressed() -> void:
	$ActionButtons.set_new_model()
	$SignalGraph.set_new_model()
	_set_is_model(true)
	
	
func _on_open_button_pressed() -> void:
	$OpenFileDialog.popup()
	
	
func _on_open_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	
	$ActionButtons.set_action_dicts(json.get('actions') as Array)
	$SignalGraph.set_sensor_dicts(json.get('sensors') as Array)
	_set_is_model(true, path)
	
	
func _on_close_button_pressed() -> void:
	if _is_dirty():
		$CloseConfirmationDialog.popup()
	else:
		_set_is_dirty(false)
		_set_is_model(false)
	
	
func _on_close_confirmation_dialog_confirmed() -> void:
	_close_after_save = true
	if (!_get_is_model_file()):
		$SaveFileDialog.popup()
	else:
		_write_file()
	
	
func _on_close_confirmation_dialog_custom_action(action: StringName) -> void:
	if action == DONT_SAVE:
		_set_is_dirty(false)
		_set_is_model(false)
	else:
		print("Unknown save confirmation dialog custom action.")
		
	$CloseConfirmationDialog.hide()
	
	
func _on_save_button_pressed() -> void:
	_close_after_save = false
	if (!_get_is_model_file()):
		$SaveFileDialog.popup()
	else:
		_write_file()
	
	
func _on_save_as_button_pressed() -> void:
	_close_after_save = false
	$SaveFileDialog.popup()
	
	
func _on_save_file_dialog_file_selected(path: String) -> void:
	_set_is_model(true, path)
	_write_file()
	
	
func _write_file() -> void:
	var file = FileAccess.open($SubHeader.text, FileAccess.WRITE)
	var content = JSON.stringify(get_dict(), "\t") # Remove the tab to reduce file size someday?
	file.store_line(content)
	_set_is_dirty(false)
	if _close_after_save:
		_set_is_model(false)
	
func get_dict() -> Dictionary:
	var dict = {}
	dict.set('actions', $ActionButtons.get_action_dicts())
	dict.set('sensors', $SignalGraph.get_sensor_dicts())
	return dict
	
	
func _set_is_model(is_model: bool, model_path: String = "") -> void:
	_is_model = is_model
	$SubHeader.visible = is_model
	$ActionButtons.visible = is_model
	$SignalGraph.visible = is_model
	$NewButton.disabled = is_model
	$OpenButton.disabled = is_model
	$CloseButton.disabled = !is_model
	$SubHeader.text = model_path
	if model_path == "":
		_is_model_file = false
	else:
		_is_model_file = true
	
	
func _get_is_model() -> bool:
	return _is_model
	
	
func _get_is_model_file() -> bool:
	return _is_model_file
	
	
func _on_action_buttons_model_changed() -> void:
	$SaveButton.disabled = false # use SaveButton.disabled as dirty flag
	
	
func _on_model_changed() -> void:
	_set_is_dirty(true)
	
	
func _set_is_dirty(is_dirty: bool) -> void:
	$SaveButton.disabled = !is_dirty # use SaveButton.disabled as dirty flag
	$SaveAsButton.disabled = !is_dirty
	
	
func _is_dirty() -> bool:
	return $SaveButton.disabled == false # use SaveButton.disabled as dirty flag
	
	

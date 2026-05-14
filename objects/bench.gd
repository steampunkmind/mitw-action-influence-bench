class_name Bench extends Node

const DONT_SAVE = "Don't Save"

var _is_model: bool = false
var _model_path: String = ""
var _is_dirty: bool = false
var _close_after_save: bool = false

enum {FILE_NEW, FILE_OPEN, FILE_CLOSE, FILE_SAVE, FILE_SAVE_AS} # index and ID

@export var frame_rate: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FileMenu.get_popup().index_pressed.connect(_on_file_menu_index_pressed)
	$FrameRateSlider.value = frame_rate
	$FrameRateValue.text = str(frame_rate)
	$CloseConfirmationDialog.add_button(DONT_SAVE, false, DONT_SAVE)
	_set_is_model(false)
	_set_is_dirty(false)
	$OpenFileDialog.set_current_dir("mitw-common/models")
	$SaveFileDialog.set_current_dir("mitw-common/models")


func _on_file_menu_index_pressed(index) -> void:
	match index:
		FILE_NEW:
			_on_file_new_menu_pressed()
		FILE_OPEN:
			_on_file_open_menu_pressed()
		FILE_CLOSE:
			_on_file_close_menu_pressed()
		FILE_SAVE:
			_on_file_save_menu_pressed()
		FILE_SAVE_AS:
			_on_file_save_as_menu_pressed()


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
	for sensor in MITW.aim_model().get_sensors():
		sensor.update_value()
	
	$SensorGraph.add_frame_to_graph()
	
	
func _on_action_button_pressed(action: Action) -> void:
	$SensorGraph.set_action(action)
	MITW.aim_model().set_action(action)
	
	
## File Functions ##
func _on_file_new_menu_pressed() -> void:
	$ActionButtons.set_new_model()
	$SensorGraph.set_new_model()
	$ActionButtons.init_action()
	_set_is_model(true)
	
	
func _on_file_open_menu_pressed() -> void:
	$OpenFileDialog.set_filters(["*.aim"])
	$OpenFileDialog.popup()
	
	
func _on_open_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	
	MITW.init(json, {})
	$ActionButtons.update_buttons()
	$SensorGraph.update_sensors()
	$ActionButtons.init_action()
	_set_is_model(true, path)
	
	
func _on_file_close_menu_pressed() -> void:
	if _is_dirty:
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
	
	
func _on_file_save_menu_pressed() -> void:
	_close_after_save = false
	if (!_get_is_model_file()):
		$SaveFileDialog.popup()
	else:
		_write_file()
	
	
func _on_file_save_as_menu_pressed() -> void:
	_close_after_save = false
	$SaveFileDialog.popup()
	
	
func _on_save_file_dialog_file_selected(path: String) -> void:
	_set_is_model(true, path)
	_write_file()
	
	
func _write_file() -> void:
	var file = FileAccess.open(_model_path, FileAccess.WRITE)
	var content = JSON.stringify(get_dict(), "\t") # Remove the tab to reduce file size someday?
	file.store_line(content)
	_set_is_dirty(false)
	if _close_after_save:
		_set_is_model(false)
	_reset_interface()
	
func get_dict() -> Dictionary:
	var dict = {}
	dict.set('actions', MITW.aim_model().get_action_dicts())
	dict.set('sensors', MITW.aim_model().get_sensor_dicts())
	return dict
	
	
func _set_is_model(is_model: bool, model_path: String = "") -> void:
	_is_model = is_model
	$Header.visible = is_model
	$Header.text = model_path.get_basename().get_file()
	_model_path = model_path
	_reset_interface()
	
	
func _get_is_model() -> bool:
	return _is_model
	
	
func _get_is_model_file() -> bool:
	return _model_path != ""
	
	
func _on_edit_actions_model_changed() -> void:
	_set_is_dirty(true)
	
	
func _on_sensor_graph_model_changed() -> void:
	_set_is_dirty(true)
	_reset_interface()
	
	
func _set_is_dirty(is_dirty: bool) -> void:
	_is_dirty = is_dirty
	
	
## Edit Actions ##
func _on_edit_actions_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$ActionButtons.clear_action_buttons()
		$EditActions.set_actions(MITW.aim_model().get_actions())
		$EditActionsButton.text = "Done"
		_disable_interface()
		$EditActionsButton.disabled = false
	else:
		$ActionButtons.update_buttons();
		$EditActions.clear_edit_action_rows()
		$EditActionsButton.text = "Edit Actions"
		_reset_interface()
		
	$EditActions.visible = toggled_on


func _disable_interface() -> void:
	$ActionButtons.visible = false
	$SensorGraph.visible = false
	$FileMenu.get_popup().set_item_disabled(FILE_NEW, true)
	$FileMenu.get_popup().set_item_disabled(FILE_OPEN, true)
	$FileMenu.get_popup().set_item_disabled(FILE_CLOSE, true)
	$FileMenu.get_popup().set_item_disabled(FILE_SAVE, true)
	$FileMenu.get_popup().set_item_disabled(FILE_SAVE_AS, true)


func _reset_interface() -> void:
	$ActionButtons.visible = _is_model
	$SensorGraph.visible = _is_model
	$FileMenu.get_popup().set_item_disabled(FILE_NEW, _is_model)
	$FileMenu.get_popup().set_item_disabled(FILE_OPEN, _is_model)
	$FileMenu.get_popup().set_item_disabled(FILE_CLOSE, !_is_model)
	$FileMenu.get_popup().set_item_disabled(FILE_SAVE, !_is_dirty)
	$FileMenu.get_popup().set_item_disabled(FILE_SAVE_AS, !_is_dirty)
	$EditActionsButton.disabled = !_is_model


func _on_eye_button_toggled(toggled_on: bool) -> void:
	# Disable this until editing interface is implemented
	# if toggled_on:
	# $EditActionsButton.show()
	# else:
	# $EditActionsButton.hide()
	MITW.aim_model().set_edit_mode(toggled_on)
	$ActionButtons.show_hide_buttons()
	$SensorGraph.update_edit_mode()

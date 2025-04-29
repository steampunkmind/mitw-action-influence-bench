class_name SignalGraphRow
extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	$Min.text = str(value)
	
func set_signal_max(value: float) -> void:
	$Max.text = str(value)

func set_signal_value(value: float) -> void:
	$Value.text = str(value)

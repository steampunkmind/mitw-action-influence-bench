class_name EditActionRow
extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_action(action: Action) -> void:
	set_name(action.get_name()) # sets name of node
	set_action_name(action.get_name())


func set_action_name(value: String) -> void:
	$Name.text = value


func set_row_location(y: float) -> void:
	var p = get_position()
	p.y = y
	set_position(p)
